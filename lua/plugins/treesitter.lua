return {
  { 
    'nvim-treesitter/nvim-treesitter', build = ':TSUpdate',
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require('nvim-treesitter.configs').setup({
        highlight = {
          enable = true,
          disable = function(_, buf) return vim.api.nvim_buf_line_count(buf) > 5000 end,
        },
        ensure_installed = { 'lua', 'vim', 'vimdoc', 'cpp', 'python', 'julia', 'haskell', 'markdown' },
      })
    end
  },
  { 'windwp/nvim-autopairs', event = 'InsertEnter',
    config = function() require('nvim-autopairs').setup({}) end },
}
