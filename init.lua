if vim.loader then vim.loader.enable() end

pcall(require, "jaze.local")

-- vim.g.loaded_python3_provider         = 0
if not vim.g.python3_host_prog or vim.g.python3_host_prog == "" then
  if vim.fn.has("win32") == 1 then
    vim.g.python3_host_prog = "C:\\Users\\angel\\AppData\\Local\\Programs\\Python\\Python312\\python.exe"
  elseif vim.fn.has("unix") == 1 then
    vim.g.python3_host_prog = "/usr/bin/python3"
  end
end
vim.g.loaded_ruby_provider            = 0
vim.g.loaded_perl_provider            = 0
vim.g.loaded_node_provider            = 0

vim.g.mapleader, vim.g.maplocalleader = ' ', ' '

-- no background color for the main background of neovim
vim.cmd("highlight Normal guibg=NONE")

require("jaze.settings")
require("jaze.keymaps")
require("jaze.cursor").setup()

-- vim.api.nvim_create_autocmd({"VimEnter", "FocusGained", "BufWinEnter"}, {
--   callback = function()
--     vim.cmd("redraw!")
--   end,
-- })

-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ 'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins from lua/plugins/*.lua
require('lazy').setup('plugins', { ui = { border = 'rounded' } })

-- Native LSP
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {
  desc = "Go to definition",
})

vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, {
  desc = "Go to type definition",
})

vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {
  desc = "Go to implementation",
})

vim.keymap.set('n', 'gr', vim.lsp.buf.references, {
  desc = "List references",
})

vim.keymap.set('n', 'K', vim.lsp.buf.hover, {
  desc = "Show hover documentation",
})

vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {
  desc = "Rename symbol",
})

vim.keymap.set({'n', 'v'}, '<leader>ac', vim.lsp.buf.code_action, {
  desc = "LSP code action",
})

vim.keymap.set('n', '[g', function()
  vim.diagnostic.jump({ count = -1, float = true })
end, {
  desc = "Previous diagnostic",
})

vim.keymap.set('n', ']g', function()
  vim.diagnostic.jump({ count = 1, float = true })
end, {
  desc = "Next diagnostic",
})

vim.keymap.set('n', '<leader>qf', function()
  vim.lsp.buf.code_action({
    filter = function(action)
      return action.isPreferred
    end,
    apply = true,
  })
end, {
  desc = "Apply preferred quick fix",
})

-- Catches typos and works inline while writing
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "latex", "typst" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

local function switch_source_header()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({
    bufnr = bufnr,
    name = "clangd",
  })

  local client = clients[1]

  if not client then
    vim.notify(
      "clangd is not attached to this buffer",
      vim.log.levels.WARN
    )
    return
  end

  local params = {
    uri = vim.uri_from_bufnr(bufnr),
  }

  client:request(
    "textDocument/switchSourceHeader",
    params,
    function(err, result)
      if err then
        vim.notify(
          "clangd source/header switch failed: " .. err.message,
          vim.log.levels.ERROR
        )
        return
      end

      if not result or result == "" then
        vim.notify(
          "No corresponding source/header file found",
          vim.log.levels.INFO
        )
        return
      end

      vim.schedule(function()
        vim.cmd.edit(vim.uri_to_fname(result))
      end)
    end,
    bufnr
  )
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp" },
  callback = function(event)
    vim.keymap.set('n', '<leader>sh', switch_source_header, {
      buffer = event.buf,
      silent = true,
      desc = "Switch source/header",
    })
  end,
})

-- Shell helper for timing long-running commands: scripts/timer.sh
vim.api.nvim_create_user_command("Time", function(opts)
  local cmd = opts.args
  local start = vim.loop.hrtime()
  vim.fn.system(cmd)
  local elapsed = (vim.loop.hrtime() - start) / 1e9
  local code = vim.v.shell_error
  local msg = string.format("Took %.3fs (exit %d)", elapsed, code)
  print(msg)

  local log = vim.fs.normalize(vim.fn.expand("~/timings.log"))
  local f = io.open(log, "a")
  if f then
    f:write(string.format(
      "%s | %s | %.3fs | exit=%d\n",
      os.date("%Y-%m-%d %H:%M:%S"),
      cmd,
      elapsed,
      code
    ))
    f:close()
  end
end, { nargs = "+", complete = "shellcmd" })
