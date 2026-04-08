local map = vim.keymap.set

-- Edit/reload config
map('n', '<Leader>ev', ':e $LOCALAPPDATA/nvim/init.lua<CR>', { silent = true })
map('n', '<Leader>sv', ':luafile $LOCALAPPDATA/nvim/init.lua<CR>', { silent = true })

-- HABITS PRESERVED
vim.opt.timeoutlen=150
map('n', '<Leader>cd', ':cd %:p:h')
map('n', '<Leader>sd', ':tcd %:p:h') -- avoiding `set autochdir` in init.lua

map('n', '<Leader>b', '^')
map('n', '<Leader>e', ':e .<CR>', { silent = true })

map('n', '<Leader>r', '<C-r>')
map('n', '<Leader>j', '<C-W><C-J>')

map('n', '<Leader>u', 'i_<ESC>r')
map('n', '<Leader>n', ':vs<CR>', { silent = true })

map('n', '<Leader>q', ':q<CR>',  { silent = true })
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
map('i', '<F9>', '<ESC>:w<CR>:!g++ -fsanitize=address -std=c++20 -Wall -Wextra -Wshadow -DONPC -O2 -o \"%<\" \"%\" && \"./%<\" <CR>')

map('n', '<F10>', ':w<CR>:!g++ -fsanitize=address -std=c++20 -Wall -Wextra -Wshadow -DONPC -O2 -o %< % && ./%< < inp<CR>')
map('i', '<F10>', '<ESC>:w<CR>:!g++ -fsanitize=address -std=c++20 -Wall -Wextra -Wshadow -DONPC -O2 -o \"%<\" \"%\" && \"./%<\" < inp<CR>')

map('n', '<C-n>', ':NERDTreeToggle<CR>', { silent = true })
map('n', '<Leader>l', ':Lazy<Return>', { silent = true })

vim.keymap.set('n', '<F2>', ':Switch<CR>', { silent = true })
vim.keymap.set('n', '<leader>f', '<Plug>(coc-format)')

-- Julia REPL via toggleterm
vim.keymap.set("n", "<leader>jr", function()
    local Terminal = require("toggleterm.terminal").Terminal
    local julia = Terminal:new({ 
        cmd = "C:/Users/angel/.julia/juliaup/julia-1.12.5+0.x64.w64.mingw32/bin/julia.exe",
        direction = "vertical",
        size = 80,
    })
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
