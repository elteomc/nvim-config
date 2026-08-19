return {
  'Julian/lean.nvim',
  event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },
  dependencies = { 'nvim-lua/plenary.nvim' },
  init = function()
    vim.g.lean_config = {
      mappings = true,
    }
  end,
}

