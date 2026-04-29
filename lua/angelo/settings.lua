local o, wo = vim.o, vim.wo
pcall(function() vim.loader.enable() end)

local A = vim.g.angelo or {}

-- Shell: optional overrides from lua/angelo/local.lua (WSL/Linux vs Windows).
if A.shell and type(A.shell) == "string" then
  vim.opt.shell = A.shell
  if A.shellcmdflag then vim.opt.shellcmdflag = A.shellcmdflag end
  if A.shellquote ~= nil then vim.opt.shellquote = A.shellquote end
  if A.shellxquote ~= nil then vim.opt.shellxquote = A.shellxquote end
elseif vim.fn.has("win32") == 1 then
  if vim.fn.executable("pwsh") == 1 then
    vim.opt.shell = "pwsh"
    vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  elseif vim.fn.executable("powershell") == 1 then
    vim.opt.shell = "powershell"
    vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  end
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
elseif vim.fn.has("unix") == 1 then
  vim.opt.shell = "bash"
end

o.termguicolors = true
o.encoding = 'utf-8'
wo.number, wo.relativenumber = true, true
o.tabstop, o.shiftwidth, o.expandtab = 2, 2, true
o.softtabstop = 2
o.smartindent, o.autoindent = true, true
o.ruler, o.showcmd, o.incsearch, o.hlsearch = true, true, true, true
o.clipboard, o.ignorecase, o.smartcase = 'unnamedplus', true, true
o.autoread, o.history, o.errorbells, o.belloff, o.swapfile = true, 1000, false, 'all', false
vim.opt.cino:append('L0'); vim.opt.iskeyword:append(':')

-- cd to current file’s folder on startup
vim.api.nvim_create_autocmd('VimEnter', { callback = function()
  pcall(vim.cmd, 'silent! lcd %:p:h')
end })

-- Less noisy diagnostics + a perf toggle
vim.diagnostic.config({ update_in_insert = false, virtual_text = { spacing = 2, prefix = '●' } })
vim.keymap.set('n', '<leader>pp', function()
  local off = not not vim.b._diag_off
  if off then
    vim.b._diag_off = false; vim.diagnostic.enable(true, { bufnr = 0 }); pcall(vim.cmd, 'TSBufEnable highlight')
    print('Perf mode: OFF')
  else
    vim.b._diag_off = true;  vim.diagnostic.enable(false, { bufnr = 0 }); pcall(vim.cmd, 'TSBufDisable highlight')
    print('Perf mode: ON')
  end
end, { desc = 'Toggle perf mode (TS+diagnostics)' })

vim.api.nvim_create_user_command('Switch', function()
  local all = vim.fn.getcompletion('', 'color')
  
  local list = vim.tbl_filter(function(name)
    return name:match('^tokyonight') or
           name:match('^oxocarbon') or
           name:match('^solarized') or
           name:match('^kanagawa') or
           name:match('^catppuccin') or
           name == 'cyberdream' or
           name == 'gruvbox'
  end, all)

  table.sort(list)
  
  vim.ui.select(list, { prompt = 'Pick a colorscheme' }, function(choice)
    if choice then pcall(vim.cmd.colorscheme, choice) end
  end)
end, {})

-- vim.opt.shell = "pwsh"
-- vim.opt.shellcmdflag = "-NoLogo -NoExit -ExecutionPolicy RemoteSigned -Command"
