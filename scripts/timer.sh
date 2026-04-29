#!/usr/bin/env bash
# Bash / Git Bash / WSL timer - add to ~/.bashrc:
#   source "$HOME/AppData/Local/nvim/scripts/timer.sh"   # adjust path (use stdpath config on Unix)
# Unix:
#   source "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/scripts/timer.sh"
# Usage: timer sleep 3

timer() {
  local start now elapsed pid hours mins secs spin i r dur_str code end
  spin='-|\/'
  i=0
  local log_file="${TIMER_LOG:-$HOME/timings.log}"

  start=$(date +%s)
  "$@" &
  pid=$!

  while kill -0 "$pid" 2>/dev/null; do
    now=$(date +%s)
    elapsed=$((now - start))
    hours=$((elapsed / 3600))
    mins=$(((elapsed % 3600) / 60))
    secs=$((elapsed % 60))
    r=$((i++ % 4))
    if [ "$hours" -gt 0 ]; then
      printf "\r[%s] %02d:%02d:%02d" "${spin:r:1}" "$hours" "$mins" "$secs"
    else
      printf "\r[%s] %02d:%02d" "${spin:r:1}" "$mins" "$secs"
    fi
    sleep 2
  done

  wait "$pid"
  code=$?

  end=$(date +%s)
  elapsed=$((end - start))
  hours=$((elapsed / 3600))
  mins=$(((elapsed % 3600) / 60))
  secs=$((elapsed % 60))

  printf "\n"
  if [ "$hours" -gt 0 ]; then
    dur_str=$(printf '%02d:%02d:%02d' "$hours" "$mins" "$secs")
    printf '[✓] %s\n' "$dur_str"
  else
    dur_str=$(printf '%02d:%02d' "$mins" "$secs")
    printf '[✓] %s\n' "$dur_str"
  fi

  printf '%s | %s | %s | exit=%s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" "$dur_str" "$code" >>"$log_file"

  return "$code"
}
