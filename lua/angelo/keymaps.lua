local map = vim.keymap.set

-- Edit/reload config
map('n', '<Leader>ev', function()
  local config_dir = vim.fn.stdpath("config")
  local config_path = vim.fn.fnamemodify(
    config_dir .. "/init.lua",
    ":p"
  )
  vim.cmd.tcd(config_dir)
  vim.cmd.edit(config_path)
  -- vim.cmd("edit " .. vim.fn.fnameescape(config))
end, { silent = true })
-- map('n', '<Leader>ev', ':e $LOCALAPPDATA/nvim/init.lua<CR>', { silent = true })
-- map('n', '<Leader>sv', ':luafile $LOCALAPPDATA/nvim/init.lua<CR>', { silent = true })

-- HABITS PRESERVED
vim.opt.timeoutlen = 150
map('n', '<Leader>cd', ':cd %:p:h')
map('n', '<Leader>sd', ':tcd %:p:h') -- avoiding `set autochdir` in init.lua
-- map('n', '\\', function()
--   vim.fn.setreg('+', vim.fn.expand('%:p'))
--   vim.notify('Copied: ' .. vim.fn.expand('%:p'))
-- end, { silent = true, desc = 'Copy full file path' })
map('n', '\\', function()
  local path

  if vim.bo.filetype == "oil" then
    path = require("oil").get_current_dir()
  else
    path = vim.fn.expand('%:p')
  end

  path = vim.fn.fnamemodify(path, ':p')
  vim.fn.setreg('+', path)
  vim.notify('Copied: ' .. path)
end, { silent = true, desc = 'Copy full file path' })

map('n', '<Leader>b', '^')
map('n', '<Leader>e', ':e .<CR>', { silent = true })

-- map('n', '<Leader>r', '<C-r>')
map('n', '<Leader>j', '<C-W><C-J>')

map('n', '<Leader>u', 'i_<ESC>r')
map('n', '<Leader>n', ':vs<CR>', { silent = true })

map('n', '<Leader>q', ':q<CR>', { silent = true })
map('n', '<Leader>a', 'ggVG')

-- map('n', '<Leader>/', '0i//<ESC>')
map('n', '<Leader>/', 'gcc', { remap = true })
map('v', '<Leader>/', 'gc', { remap = true })

map('n', '<Tab>', '%')
map('i', 'jk', '<ESC>')

-- New tab
map('n', 'te', ':tabedit')

map('n', '<Leader>wv', ':vsplit<Return>')
map('n', '<Leader>ws', ':split<Return>')
-- Move windows
map('n', '<Leader>wh', '<C-w>h')
map('n', '<Leader>wk', '<C-w>k')
map('n', '<Leader>wj', '<C-w>j')
map('n', '<Leader>wl', '<C-w>l')

-- C++ (peltorator)

map('n', '<F1>', ':tabprev<CR>', { silent = true }); map('i', '<F1>', '<ESC>')

map('n', '<F3>', ':w<CR>:make<CR>', { silent = true }); map('i', '<F3>', '<ESC>:w<CR>:make<CR>', { silent = true })
map('n', '<F7>', ':w<CR>:!python3 %<CR>', { silent = true })

map('n', '<F8>', ':w<CR>:!g++ -fsanitize=address -std=c++20 -DONPC -O2 -o %< % && ./%< < inp<CR>')
map('i', '<F8>', '<ESC>:w<CR>:!g++ -fsanitize=address -std=c++20 -DONPC -O2 -o \"%<\" \"%\" && \"./%<\" < inp<CR>')

map('n', '<F9>', ':w<CR>:!g++ -fsanitize=address -std=c++20 -Wall -Wextra -Wshadow -DONPC -O2 -o %< % && ./%< <CR>')
map('i', '<F9>',
  '<ESC>:w<CR>:!g++ -fsanitize=address -std=c++20 -Wall -Wextra -Wshadow -DONPC -O2 -o \"%<\" \"%\" && \"./%<\" <CR>')

map('n', '<F10>', ':w<CR>:!g++ -fsanitize=address -std=c++20 -Wall -Wextra -Wshadow -DONPC -O2 -o %< % && ./%< < inp<CR>')
map('i', '<F10>',
  '<ESC>:w<CR>:!g++ -fsanitize=address -std=c++20 -Wall -Wextra -Wshadow -DONPC -O2 -o \"%<\" \"%\" && \"./%<\" < inp<CR>')

map('n', '<C-n>', ':NERDTreeToggle<CR>', { silent = true })
map('n', '<Leader>l', ':Lazy<Return>', { silent = true })

vim.keymap.set('n', '<F2>', ':Switch<CR>', { silent = true })
vim.keymap.set('n', '<leader>f', '<Plug>(coc-format)')

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  
  callback = function()
    local Terminal = require("toggleterm.terminal").Terminal
    
    local julia = Terminal:new({
      cmd = "C:/Users/angel/.julia/juliaup/julia-1.12.5+0.x64.w64.mingw32/bin/julia.exe",
      direction = "vertical",
      size = 300,
    })
    
    -- Julia REPL via toggleterm
    vim.keymap.set("n", "<leader>jr", function()
      julia:toggle()
    end, { desc = "Toggle Julia REPL" })

    -- Send current line to REPL
    vim.keymap.set("n", "<leader>jl", function()
      local line = vim.api.nvim_get_current_line()
      julia:send(line)
    end, { desc = "Send line to Julia" })

    -- Send visual selection to REPL
    vim.keymap.set("v", "<leader>js", function()
      local lines = vim.fn.getline("'<", "'>")
      julia:send(table.concat(lines, "\n"))
    end, { desc = "Send selection to Julia" })
  end,
})



-- ── tx CLI integration ────────────────────────────────
-- Press <Esc> or q to close after nvim re-opens the chosen file

local function tx(cmd)
  -- Build the PowerShell command
  local ps_cmd = string.format(
    'powershell.exe -NoProfile -Command "& \'%s\\TeXMeOut\\tools\\tx.ps1\' %s"',
    os.getenv("USERPROFILE"):gsub("\\", "\\\\"),
    cmd
  )

  -- Floating window dimensions
  local width  = math.floor(vim.o.columns * 0.85)
  local height = math.floor(vim.o.lines * 0.80)
  local row    = math.floor((vim.o.lines - height) / 2)
  local col    = math.floor((vim.o.columns - width) / 2)

  -- Create scratch buffer
  local buf    = vim.api.nvim_create_buf(false, true)

  -- Open floating window
  local win    = vim.api.nvim_open_win(buf, true, {
    relative  = "editor",
    width     = width,
    height    = height,
    row       = row,
    col       = col,
    style     = "minimal",
    border    = "rounded",
    title     = string.format(" tx %s ", cmd),
    title_pos = "center",
  })

  -- Run terminal inside it
  vim.fn.termopen(ps_cmd, {
    on_exit = function(_, exit_code, _)
      -- Close the floating window when the command finishes
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end,
  })

  -- Start in insert mode so fzf is immediately interactive
  vim.cmd("startinsert")

  -- Allow closing with Esc when fzf isn't active (e.g. after it exits)
  vim.keymap.set("t", "<Esc>", function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, { buffer = buf, nowait = true })
end

-- What business do you actually mean: Tool company for funds, a hedge fund, or a hybrid??
-- What exactly is the advantage/wedge? Which exact problem are we attacking first that a 3-10 person team with AI can do better than a larger firm?
-- What is the first milestone? What would we need to prove in 90 days to know this is worth continuing?
-- What parts stay human?
-- Who are you?

-- ── keymaps (all under <leader>x — "teXout") ────────────────────────────────
--
--   <leader>xn  ->  tx new      create HW / lecture / note (fzf-guided)
--   <leader>xo  ->  tx open     fuzzy-open any .typ file
--   <leader>xr  ->  tx recent   50 most recently edited files
--   <leader>xs  ->  tx search   full-text search (requires ripgrep)
--   <leader>xd  ->  tx daily    today's journal entry
--
-- Using <leader>x to avoid clash with your existing <leader>t (if any).
-- Change the prefix to whatever you prefer.
-- keys left to use with <leader>: d, i, k, m, u, v, x, y, z
-- todo: instead of x use .

vim.keymap.set("n", "<leader>xn", function() tx("new") end, { desc = "tx: new file" })
vim.keymap.set("n", "<leader>xo", function() tx("open") end, { desc = "tx: open file" })
vim.keymap.set("n", "<leader>xr", function() tx("recent") end, { desc = "tx: recent files" })
vim.keymap.set("n", "<leader>xs", function() tx("search") end, { desc = "tx: search notes" })
vim.keymap.set("n", "<leader>xd", function() tx("daily") end, { desc = "tx: daily journal" })

-- Bonus: quick Typst compile + open PDF for current file
-- <leader>xc  →  compile current .typ and open PDF in default viewer
vim.keymap.set("n", "<leader>xc", function()
  local file        = vim.fn.expand("%:p")
  local dir         = vim.fn.expand("%:p:h")
  local stem        = vim.fn.expand("%:t:r")
  local pdf         = dir .. "\\target\\" .. stem .. ".pdf"

  local compile_cmd = string.format(
    'powershell.exe -NoProfile -Command "typst compile \'%s\' \'%s\'"',
    file, pdf
  )

  vim.notify("Compiling " .. stem .. ".typ …", vim.log.levels.INFO)

  vim.fn.jobstart(compile_cmd, {
    on_exit = function(_, code, _)
      if code == 0 then
        vim.notify("✓ " .. stem .. ".pdf", vim.log.levels.INFO)
        -- Open PDF in default viewer
        vim.fn.jobstart(string.format('powershell.exe -Command "Start-Process \'%s\'"', pdf))
      else
        vim.notify("✗ Typst compile failed", vim.log.levels.ERROR)
      end
    end,
  })
end, { desc = "tx: compile current file" })

-- <leader>xw  →  toggle typst watch for current file
local _watch_job = nil
vim.keymap.set("n", "<leader>xw", function()
  if _watch_job then
    vim.fn.jobstop(_watch_job)
    _watch_job = nil
    vim.notify("Typst watch stopped", vim.log.levels.INFO)
  else
    local file = vim.fn.expand("%:p")
    local root = os.getenv("USERPROFILE") .. "\\TeXMeOut"
    local cmd  = string.format(
      'powershell.exe -NoProfile -Command "typst watch \'%s\' --root \'%s\'"',
      file, root
    )
    _watch_job = vim.fn.jobstart(cmd, {
      on_stderr = function(_, data, _)
        if data and #data > 0 and data[1] ~= "" then
          vim.schedule(function()
            vim.notify(table.concat(data, "\n"), vim.log.levels.WARN)
          end)
        end
      end,
    })
    vim.notify("Typst watch started → " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
  end
end, { desc = "tx: toggle typst watch" })
