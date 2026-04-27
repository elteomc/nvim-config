-- after/ftplugin/tex.lua
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"
vim.opt_local.conceallevel = 1

-- indentation tends to be personal
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.expandtab = true

-- TeX-only keymaps (examples)
vim.keymap.set("n", "<leader>lt", "<cmd>VimtexTocOpen<cr>", { buffer = true, desc = "VimTeX TOC" })
vim.keymap.set("n", "<leader>le", "<cmd>VimtexErrors<cr>", { buffer = true, desc = "VimTeX errors" })

