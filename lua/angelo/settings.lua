local o, wo = vim.o, vim.wo
pcall(function() vim.loader.enable() end)

o.termguicolors = true
o.encoding = 'utf-8'
wo.number, wo.relativenumber = true, true
o.tabstop, o.shiftwidth, o.expandtab = 4, 4, true
o.smartindent, o.autoindent = true, true
o.ruler, o.showcmd, o.incsearch, o.hlsearch = true, true, true, true
o.clipboard, o.ignorecase, o.smartcase = 'unnamedplus', true, true
o.autoread, o.history, o.errorbells, o.belloff, o.swapfile = true, 1000, false, 'all', false
vim.opt.cino:append('L0'); vim.opt.iskeyword:append(':')

-- Use Git Bash on Windows (matches your old config)
if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
  o.shell        = [[C:\Program Files\Git\usr\bin\bash.exe]]
  o.shellcmdflag = '-c'; o.shellquote = ''; o.shellxquote = ''
end

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
           name == 'gruvbox'
  end, all)

  table.sort(list)
  
  vim.ui.select(list, { prompt = 'Pick a colorscheme' }, function(choice)
    if choice then pcall(vim.cmd.colorscheme, choice) end
  end)
end, {})

-- vim.opt.shell = "pwsh"
-- vim.opt.shellcmdflag = "-NoLogo -NoExit -ExecutionPolicy RemoteSigned -Command"
