if vim.loader then vim.loader.enable() end

pcall(require, "angelo.local")

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

require("angelo.settings")
require("angelo.keymaps")
require("angelo.cursor").setup()

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

-- C++ integrated CoC
local map = function(lhs, rhs) vim.api.nvim_set_keymap('n', lhs, rhs, { silent = true, noremap = false }) end
map('gd', '<Plug>(coc-definition)')
map('gy', '<Plug>(coc-type-definition)')
map('gi', '<Plug>(coc-implementation)')
map('gr', '<Plug>(coc-references)')
vim.api.nvim_set_keymap('n', 'K', ':call CocActionAsync("doHover")<CR>', { silent = true, noremap = true })
map('<leader>rn', '<Plug>(coc-rename)')
map('<leader>qf', '<Plug>(coc-fix-current)')
map('<leader>ac', '<Plug>(coc-codeaction)')
map('[g', '<Plug>(coc-diagnostic-prev)')
map(']g', '<Plug>(coc-diagnostic-next)')

vim.g.coc_start_at_startup = 0 -- coc does not start automatically on launch

-- vim.api.nvim_set_keymap('n', '<leader>sh', ':CocCommand clangd.switchSourceHeader<CR>', {silent=true, noremap=true})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "bash", "json", "haskell", "vim", "markdown", "c", "cpp", "objc", "objcpp", "python" },
  callback = function()
    vim.cmd("silent! CocStart")
    vim.keymap.set('n', '<leader>sh', ':CocCommand clangd.switchSourceHeader<CR>', {
      buffer = true,
      silent = true,
      noremap = true
    })
  end,
})

-- vim.keymap.set("i", "<CR>", function()
--   if vim.fn["coc#pum#visible"]() == 1 then
--     return vim.fn["coc#pum#confirm"]()
--   end
--
--   local cmp = package.loaded["cmp"]
--   if cmp and cmp.visible() then
--     return cmp.confirm({ select = true })
--   end
--
--   return "\r"
-- end, { expr = true, silent = true })

-- Catches typos and works inline while writing
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "latex", "typst" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- if vim.fn.has('win32') == 1 then
--   vim.opt.shell = 'C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe' -- or 'pwsh.exe' if you have it
--   vim.opt.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy Bypass -Command'
--   vim.opt.shellquote = ''
--   vim.opt.shellxquote = ''
--   vim.opt.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
--   vim.opt.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
--   vim.opt.shellslash = false
-- end

vim.api.nvim_create_user_command("Time", function(opts)
  local start = vim.loop.hrtime()
  vim.fn.system(opts.args)
  local elapsed = (vim.loop.hrtime() - start) / 1e9
  print(string.format("Took %.3fs", elapsed))
end, { nargs = "+" })
