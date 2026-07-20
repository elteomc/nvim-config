local M = {}

local function setup_yank_highlight()
  local group = vim.api.nvim_create_augroup(
    "JazeYankHighlight",
    { clear = true }
  )

  vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    callback = function()
      vim.highlight.on_yank({
        timeout = 150,
      })
    end,
  })
end

local function setup_parent_directory_creation()
  local group = vim.api.nvim_create_augroup(
    "JazeCreateParentDirectory",
    { clear = true }
  )

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    callback = function(event)
      if event.match:match("^%w%w+:[\\/][\\/]") then
        return
      end

      local parent = vim.fs.dirname(event.match)

      if parent then
        vim.fn.mkdir(parent, "p")
      end
    end,
  })
end

local function setup_external_change_detection()
  local group = vim.api.nvim_create_augroup(
    "JazeCheckTime",
    { clear = true }
  )

  vim.api.nvim_create_autocmd({
    "FocusGained",
    "BufEnter",
    "CursorHold",
    "TermLeave",
  }, {
    group = group,
    callback = function()
      if vim.fn.getcmdwintype() == "" then
        vim.cmd.checktime()
      end
    end,
  })
end

local function setup_terminal_buffers()
  local group = vim.api.nvim_create_augroup(
    "JazeTerminal",
    { clear = true }
  )

  vim.api.nvim_create_autocmd("TermOpen", {
    group = group,
    callback = function()
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.signcolumn = "no"
    end,
  })

  vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", {
    desc = "Leave terminal mode",
  })
end

local function setup_quick_close()
  local group = vim.api.nvim_create_augroup(
    "JazeQuickClose",
    { clear = true }
  )

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = {
      "checkhealth",
      "help",
      "lspinfo",
      "man",
      "notify",
      "qf",
    },
    callback = function(event)
      vim.keymap.set("n", "q", "<cmd>close<cr>", {
        buffer = event.buf,
        silent = true,
        desc = "Close window",
      })
    end,
  })
end

local function setup_time_command()
  vim.api.nvim_create_user_command("Time", function(opts)
    local command = opts.args
    local start = vim.uv.hrtime()

    local output = vim.fn.system(command)
    local exit_code = vim.v.shell_error
    local elapsed = (vim.uv.hrtime() - start) / 1e9

    local message = string.format(
      "Took %.3fs (exit %d)",
      elapsed,
      exit_code
    )

    vim.notify(
      message,
      exit_code == 0
        and vim.log.levels.INFO
        or vim.log.levels.ERROR
    )

    local log_path = vim.fn.expand("~/timings.log")
    local file = io.open(log_path, "a")

    if file then
      file:write(string.format(
        "%s | %s | %.3fs | exit=%d\n",
        os.date("%Y-%m-%d %H:%M:%S"),
        command,
        elapsed,
        exit_code
      ))
      file:close()
    end

    if exit_code ~= 0 and output ~= "" then
      vim.notify(output, vim.log.levels.ERROR)
    end
  end, {
    nargs = "+",
    complete = "shellcmd",
  })

  vim.api.nvim_create_user_command("TimingLog", function()
    local log_path = vim.fn.expand("~/timings.log")

    vim.cmd(
      "botright split " .. vim.fn.fnameescape(log_path)
    )
  end, {})
end

local function setup_which_command()
  vim.api.nvim_create_user_command("Which", function(opts)
    local executable = vim.fn.exepath(opts.args)

    if executable == "" then
      vim.notify(
        opts.args .. " was not found in Neovim's PATH",
        vim.log.levels.WARN
      )
      return
    end

    vim.notify(executable)
  end, {
    nargs = 1,
    complete = "shellcmd",
  })
end

function M.setup()
  setup_yank_highlight()
  setup_parent_directory_creation()
  setup_external_change_detection()
  setup_terminal_buffers()
  setup_quick_close()
  setup_time_command()
  setup_which_command()
end

return M
