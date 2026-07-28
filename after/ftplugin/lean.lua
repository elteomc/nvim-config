-- Treat backslash as part of the word so 'sc' won't match inside '\sc'
vim.opt_local.iskeyword:append('\\')

-- Remove the emoji completion source just for Lean buffers
local ok_cmp, cmp = pcall(require, 'cmp')
if ok_cmp then
  cmp.setup.buffer({
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' }, -- drop if you don't use snippets in Lean
      { name = 'path' },
      { name = 'buffer' },
    }),
  })
end

-- If friendly-snippets or another pack injects emoji snippets globally:
pcall(function()
  require('luasnip').filetype_set('lean', {}) -- empty snippet set for Lean
end)

