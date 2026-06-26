return {
  'stevearc/conform.nvim',
  event = "BufWritePre",
  opts = {
    format_on_save = { lsp_fallback = true, timeout_ms = 2500 },
    formatters_by_ft = {
      cpp = { 'clang-format' },
      c   = { 'clang-format' },
      python = { 'black' },
      -- haskell: add 'fourmolu' or 'ormolu' later if you install them
    },
  },
}
