-- Treat backslash as part of the word so 'sc' won't match inside '\sc'
vim.opt_local.iskeyword:append('\\')

local map = vim.keymap.set

local function lean_map(lhs, rhs, desc)
  map('n', lhs, rhs, {
    buffer = true,
    silent = true,
    desc = 'Lean: ' .. desc,
  })
end

lean_map('<localleader>i', '<cmd>LeanInfoviewToggle<cr>', 'Toggle infoview')
lean_map('<localleader>o', '<cmd>LeanGoal<cr>', 'Show goal')
lean_map('<localleader>r', '<cmd>LeanRestartFile<cr>', 'Restart file')

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

-- -- If friendly-snippets or another pack injects emoji snippets globally:
-- pcall(function()
--   require('luasnip').filetype_set('lean', {}) -- empty snippet set for Lean
-- end)
