local o, wo = vim.o, vim.wo

local A = vim.g.jaze or {}

-- Providers
if not vim.g.python3_host_prog
    or vim.g.python3_host_prog == "" then
  local python = vim.fn.exepath("python3")

  if python ~= "" then
    vim.g.python3_host_prog = python
  end
end

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Shell: optional overrides from lua/jaze/local.lua (WSL/Linux vs Windows).
if A.shell and type(A.shell) == "string" then
  vim.opt.shell = A.shell
  if A.shellcmdflag then
    vim.opt.shellcmdflag = A.shellcmdflag
  end
  if A.shellquote ~= nil then
    vim.opt.shellquote = A.shellquote
  end
  if A.shellxquote ~= nil then
    vim.opt.shellxquote = A.shellxquote
  end
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
o.encoding = "utf-8"
wo.number, wo.relativenumber = true, true
o.tabstop, o.shiftwidth, o.expandtab = 2, 2, true
o.softtabstop = 2
o.smartindent, o.autoindent = true, true
o.ruler, o.showcmd, o.incsearch, o.hlsearch = true, true, true, true
o.clipboard, o.ignorecase, o.smartcase = "unnamedplus", true, true
o.autoread, o.history, o.errorbells, o.belloff, o.swapfile = true, 1000, false, "all", false
vim.opt.cino:append("L0")
vim.opt.iskeyword:append(":")

-- cd to current file’s folder on startup... NOT A GOOD IDEA LOL
-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     pcall(vim.cmd, "silent! lcd %:p:h")
--   end,
-- })

-- Less noisy diagnostics + a perf toggle
vim.diagnostic.config({ update_in_insert = false, virtual_text = { spacing = 2, prefix = "●" } })
vim.keymap.set("n", "<leader>pp", function()
  local off = not not vim.b._diag_off
  if off then
    vim.b._diag_off = false
    vim.diagnostic.enable(true, { bufnr = 0 })
    pcall(vim.cmd, "TSBufEnable highlight")
    print("Perf mode: OFF")
  else
    vim.b._diag_off = true
    vim.diagnostic.enable(false, { bufnr = 0 })
    pcall(vim.cmd, "TSBufDisable highlight")
    print("Perf mode: ON")
  end
end, { desc = "Toggle perf mode (TS+diagnostics)" })

--- Lazy-load optional colorscheme plugins before `:colorscheme` (see lua/plugins/ui.lua).
local function lazy_load_colorscheme_plugin(name)
  local lazy_ok, lazy_mod = pcall(require, "lazy")
  if not lazy_ok or not name then
    return
  end
  local plugins = nil
  -- Names must match lazy.nvim plugin keys (see :Lazy, lazy-lock.json).
  if name:match("^tokyonight") then
    plugins = { "tokyonight.nvim" }
  elseif name:match("^kanagawa") then
    plugins = { "kanagawa.nvim" }
  elseif name:match("^catppuccin") then
    plugins = { "catppuccin" }
  elseif name == "gruvbox" then
    plugins = { "gruvbox" }
  elseif name == "oxocarbon" then
    plugins = { "oxocarbon.nvim" }
  elseif name == "cyberdream" then
    plugins = { "cyberdream.nvim" }
  elseif name:match("^solarized") then
    return
  end
  if plugins then
    lazy_mod.load({ plugins = plugins })
  end
end

vim.api.nvim_create_user_command("Switch", function()
  local all = vim.fn.getcompletion("", "color")

  local function wanted(name)
    return name:match("^tokyonight")
        or name:match("^oxocarbon")
        or name:match("^solarized")
        or name:match("^kanagawa")
        or name:match("^catppuccin")
        or name == "cyberdream"
        or name == "gruvbox"
  end

  local seen = {}
  local list = {}

  -- Plugins may not register colors until loaded — seed names users expect from :Switch.
  for _, extra in ipairs({ "cyberdream", "oxocarbon" }) do
    if wanted(extra) then
      table.insert(list, extra)
      seen[extra] = true
    end
  end

  for _, name in ipairs(all) do
    if not seen[name] and wanted(name) then
      table.insert(list, name)
      seen[name] = true
    end
  end

  table.sort(list)

  vim.ui.select(list, { prompt = "Pick a colorscheme" }, function(choice)
    if not choice then
      return
    end
    lazy_load_colorscheme_plugin(choice)
    vim.schedule(function()
      pcall(vim.cmd.colorscheme, choice)
    end)
  end)
end, {})

vim.api.nvim_create_user_command("Z", function(opts)
  local result = vim.system({ "zoxide", "query", opts.args }, { text = true }):wait()

  if result.code ~= 0 then
    vim.notify("zoxide: no match for " .. opts.args, vim.log.levels.ERROR)
    return
  end

  local dir = vim.trim(result.stdout)

  if dir == "" then
    vim.notify("zoxide: empty result", vim.log.levels.ERROR)
    return
  end

  vim.cmd.cd(vim.fn.fnameescape(dir))        -- Make zoxide's query result the global cwd
  vim.cmd("Oil " .. vim.fn.fnameescape(dir)) -- Forcing Oil to open that exact dir
end, {
  nargs = "+",
  desc = "Jump to zoxide directory and open Oil",
})

-- Tabbing (only works whenever there are no tab characters outside of indentation)
-- For simple paragraphs, gg=G or =ap should be enough
vim.api.nvim_create_user_command("Retab2", function()
  vim.cmd([[
    set ts=4 sts=4 noet
    retab!
    set ts=2 sts=2 et
    retab
  ]])
end, {})

vim.api.nvim_create_user_command("Retab4", function()
  vim.cmd([[
    set ts=2 sts=2 noet
    retab!
    set ts=4 sts=4 et
    retab
  ]])
end, {})
