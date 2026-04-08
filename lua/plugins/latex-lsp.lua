-- -- lua/plugins/latex-lsp.lua
-- return {
--   {
--     "neovim/nvim-lspconfig",
--     ft = { "tex", "plaintex" },
--     config = function()
--       require("lspconfig").texlab.setup({
--         settings = {
--           texlab = {
--             -- Keep it light and responsive
--             diagnosticsDelay = 300,
--             chktex = { onOpenAndSave = true, onEdit = false },

--             build = {
--               executable = "latexmk",
--               args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
--               onSave = true,
--               forwardSearchAfter = true,
--             -- },

--             -- You can omit this and let VimTeX handle viewing; both work.
--             forwardSearch = {
--               executable = "SumatraPDF",
--               args = { "%p", "-reuse-instance", "-forward-search", "%f", "%l" },
--             },

--             latexindent = { modifyLineBreaks = true },
--           },
--         },
--       })
--     end,
--   },
-- }

-- lua/plugins/latex-lsp.lua
return {
  "neovim/nvim-lspconfig",
  ft = { "tex", "plaintex", "bib" },
  
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- optional: customize texlab; otherwise you can omit this call
    vim.lsp.config("texlab", {
      capabilities = capabilities,
      settings = {
        texlab = {
          build = { onSave = false },           -- let VimTeX build if you use it
          chktex = { onOpenAndSave = true },
        },
      },
    })
    
    -- enable the server (replaces require('lspconfig').texlab.setup)
    vim.lsp.enable("texlab")
  end,
}
