-- Toggle Cursor CLI Agent (cursor-agent) in a floating ToggleTerm window.

local M = {}

---@type table|nil Persistent terminal instance so <leader>ca toggles the same session.
local agent_term

local function require_toggleterm()
  local ok, term_mod = pcall(require, "toggleterm.terminal")
  if ok and term_mod then
    return term_mod
  end
  local lazy_ok, lazy = pcall(require, "lazy")
  if lazy_ok and lazy and lazy.load then
    pcall(function()
      lazy.load({ plugins = { "akinsho/toggleterm.nvim" } })
    end)
  end
  ok, term_mod = pcall(require, "toggleterm.terminal")
  if ok then
    return term_mod
  end
  return nil
end

function M.agent_executable()
  local a = vim.g.jaze or {}
  return type(a.cursor_agent) == "string" and #a.cursor_agent > 0 and a.cursor_agent or "cursor-agent"
end

local function dims()
  return math.floor(vim.o.columns * 0.9), math.floor((vim.o.lines - vim.o.cmdheight) * 0.85)
end

function M.toggle_agent()
  local cmd = M.agent_executable()
  if vim.fn.executable(cmd) ~= 1 then
    vim.notify(
      ("Cursor Agent not on PATH: %s\nInstall: https://cursor.com/cli"):format(cmd),
      vim.log.levels.WARN
    )
    return
  end

  local term_mod = require_toggleterm()
  if not term_mod or not term_mod.Terminal then
    vim.notify("toggleterm.nvim is required for Cursor Agent integration.", vim.log.levels.ERROR)
    return
  end

  if not agent_term then
    local w, h = dims()
    agent_term = term_mod.Terminal:new({
      cmd = cmd,
      dir = vim.fn.getcwd(),
      hidden = true,
      direction = "float",
      float_opts = {
        border = "curved",
        width = w,
        height = h,
        winblend = 0,
      },
      close_on_exit = true,
      on_open = function()
        vim.cmd("startinsert")
      end,
    })
  end

  agent_term:toggle()
end

function M.setup()
  vim.api.nvim_create_user_command("CursorAgent", function()
    M.toggle_agent()
  end, { desc = "Toggle Cursor CLI Agent (floating terminal)" })
end

return M
