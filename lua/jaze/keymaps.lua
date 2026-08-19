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

-- HABITS PRESERVED
vim.opt.timeoutlen = 150
map('n', '<Leader>cd', ':cd %:p:h')
map('n', '<Leader>sd', ':tcd %:p:h') -- avoiding `set autochdir` in init.lua
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
-- map('n', '<Leader>e', ':e .<CR>', { silent = true })

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

map('n', '<leader>r2', '<cmd>Retab2<CR>', { desc = "Retab to 2 spaces" })
map('n', '<leader>r4', '<cmd>Retab4<CR>', { desc = "Retab to 4 spaces" })

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

vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
  vim.lsp.buf.format({ async = true })
end, {
  desc = "Format buffer or selection",
})



vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,

  callback = function()
    local Terminal = require("toggleterm.terminal").Terminal

    local julia = Terminal:new({
      cmd = vim.fn.exepath("julia"),
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



-- tx CLI integration
-- Press <Esc> or q to close after nvim re-opens the chosen file

local function tx(cmd)
  if vim.fn.executable("tx") ~= 1 then
    vim.notify("tx executable not found in PATH", vim.log.levels.ERROR)
    return
  end

  local tx_cmd = { "tx", cmd }

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
  vim.fn.termopen(tx_cmd, {
    on_exit = function()
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

-- keymaps (all under <leader>x - "teXout")
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
-- <leader>xc  ->  compile current .typ and open PDF in default viewer
vim.keymap.set("n", "<leader>xc", function()
  if vim.bo.filetype ~= "typst" then
    vim.notify("Current buffer is not a Typst file", vim.log.levels.WARN)
    return
  end

  local file       = vim.fn.expand("%:p")
  local dir        = vim.fn.expand("%:p:h")
  local stem       = vim.fn.expand("%:t:r")
  local target_dir = dir .. "/target"
  local pdf        = target_dir .. "/" .. stem .. ".pdf"

  vim.fn.mkdir(target_dir, "p")

  vim.notify("Compiling " .. stem .. ".typ...", vim.log.levels.INFO)

  vim.fn.jobstart({
    "typst",
    "compile",
    file,
    pdf,
  }, {
    on_exit = function(_, code)
      vim.schedule(function()
        if code == 0 then
          vim.notify("Compiled " .. stem .. ".pdf", vim.log.levels.INFO)

          vim.fn.jobstart({
            "zathura",
            pdf,
          }, {
            detach = true,
          })
        else
          vim.notify("Typst compilation failed", vim.log.levels.ERROR)
        end
      end)
    end,
  })
end, { desc = "Typst: compile and open PDF" })

-- <leader>xw  ->  toggle typst watch for current file
local _watch_job = nil

vim.keymap.set("n", "<leader>xw", function()
  if _watch_job then
    vim.fn.jobstop(_watch_job)
    _watch_job = nil
    vim.notify("Typst watch stopped", vim.log.levels.INFO)
    return
  end

  if vim.bo.filetype ~= "typst" then
    vim.notify("Current buffer is not a Typst file", vim.log.levels.WARN)
    return
  end

  local file = vim.fn.expand("%:p")
  local root = vim.fn.expand("~/angelo/notes")

  _watch_job = vim.fn.jobstart({
    "typst",
    "watch",
    file,
    "--root",
    root,
  }, {
    on_stderr = function(_, data)
      if not data then
        return
      end

      local messages = vim.tbl_filter(function(line)
        return line ~= ""
      end, data)

      if #messages > 0 then
        vim.schedule(function()
          vim.notify(
            table.concat(messages, "\n"),
            vim.log.levels.WARN
          )
        end)
      end
    end,

    on_exit = function()
      _watch_job = nil
    end,
  })

  if _watch_job <= 0 then
    _watch_job = nil
    vim.notify("Failed to start Typst watch", vim.log.levels.ERROR)
    return
  end

  vim.notify(
    "Typst watch started: " .. vim.fn.expand("%:t"),
    vim.log.levels.INFO
  )
end, {
  desc = "Typst: toggle watch",
})
