return {
  'Julian/lean.nvim',
  event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = { mappings = true },  -- <localleader>i toggles infoview (space+i in your setup)
}