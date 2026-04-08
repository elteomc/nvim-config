return {
  'neovim/nvim-lspconfig',
  config = function()
    local lsp = require('lspconfig')
    lsp.hls.setup({
      cmd = { 'haskell-language-server-wrapper', '--lsp' },
      filetypes = { 'haskell', 'lhaskell' },
    })
  end,
}