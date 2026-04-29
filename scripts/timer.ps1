# Dot-source from your PowerShell profile ($PROFILE):
#   . "$env:LOCALAPPDATA\nvim\scripts\timer.ps1"
# WSL/Linux sync: prefer scripts/timer.sh in bash instead.
#
# Usage examples:
#   timer quarto render .\report.qmd
#   timer pwsh -NoProfile -Command "Start-Sleep 3"

$script:TimerLog = if ($env:TIMER_LOG) { $env:TIMER_LOG } else { Join-Path $HOME "timings.log" }

function timer {
  param(
    [Parameter(Mandatory = $true, ValueFromRemainingArguments = $true)]
    [string[]] $Args
  )

  $exePath = Get-Command $Args[0] -CommandType Application -ErrorAction Stop | Select-Object -First 1 -ExpandProperty Source
  $argList = @()
  if ($Args.Length -gt 1) {
    $argList = $Args[1..($Args.Length - 1)]
  }

  $start = Get-Date
  $spinner = @('|', '/', '-', '\')
  $si = 0

  $p = Start-Process -FilePath $exePath -ArgumentList $argList -PassThru -NoNewWindow -Wait:$false

  while (-not $p.HasExited) {
    $elapsed = [int](((Get-Date) - $start).TotalSeconds)
    $h = [math]::Floor($elapsed / 3600)
    $m = [math]::Floor(($elapsed % 3600) / 60)
    $s = $elapsed % 60
    $t = if ($h -gt 0) {
      '{0:D2}:{1:D2}:{2:D2}' -f $h, $m, $s
    } else {
      '{0:D2}:{1:D2}' -f $m, $s
    }
    Write-Host -NoNewline "`r[$($spinner[$si % 4])] $t"
    $si++
    Start-Sleep -Milliseconds 400
  }

  Write-Host ""
  $p.WaitForExit()
  $code = $p.ExitCode

  $dur = ((Get-Date) - $start).TotalSeconds
  $elapsed = [int][math]::Floor($dur)
  $h = [math]::Floor($elapsed / 3600)
  $m = [math]::Floor(($elapsed % 3600) / 60)
  $s = $elapsed % 60
  $durStr = if ($h -gt 0) {
    '{0:D2}:{1:D2}:{2:D2}' -f $h, $m, $s
  } else {
    '{0:D2}:{1:D2}' -f $m, $s
  }

  Write-Host "[✓] $durStr"

  $cmdline = $Args -join ' '
  $line = '{0} | {1} | {2} | exit={3}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $cmdline, $durStr, $code
  Add-Content -Path $script:TimerLog -Value $line -Encoding utf8

  if ($code -ne 0) {
    exit $code
  }
}
