vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.spell = true
vim.opt_local.conceallevel = 2
vim.opt_local.textwidth = 0

vim.keymap.set("n", "<Leader>qp", "<cmd>QuartoPreview<CR>", { buffer = true, desc = "Quarto preview" })
vim.keymap.set("n", "<Leader>qr", "<cmd>QuartoRender<CR>", { buffer = true, desc = "Quarto render" })
