return {
  {
    "lervag/vimtex",
    ft = { "tex", "plaintex", "bib" },
    init = function()
      vim.g.vimtex_view_method = 'general'
      vim.g.vimtex_view_general_viewer = 'SumatraPDF'
      vim.g.vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'
      
      -- Required for inverse search with Neovim
      vim.g.vimtex_compiler_progname = 'nvr'
      vim.g.vimtex_callback_progname = 'nvr'
      
      -- Build with latexmk and enable SyncTeX
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_quickfix_mode = 2

      -- IMPORTANT for snippet-first workflows:
      -- Disable VimTeX insert-mode mappings (they can fight snippets)
      vim.g.vimtex_imaps_enabled = 0
      
      -- If you rely on cmp/texlab for completion, disable VimTeX completion
      vim.g.vimtex_complete_enabled = 0
      
      -- Optional: turn off conceal if you prefer raw TeX
      -- vim.g.vimtex_syntax_conceal = { accents = 0, ligatures = 0 }
    end,
  },
}
