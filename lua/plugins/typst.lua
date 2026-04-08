return {
  -- (tiny) filetype + :TypstWatch
  { "kaarmu/typst.vim", ft = "typst" },

  -- Fast web/SVG preview with cross-jump (Tinymist-powered)
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    opts = {
      -- If you did NOT add tinymist to PATH, hardcode the path:
      dependencies_bin = {
        ['tinymist'] = "C:\\Users\\angel\\AppData\\Local\\typst_nv\\tinymist.exe"
      },
      port = 5523, -- fixed port avoids weird firewall auto-blocks
    }, -- runs :TypstPreviewUpdate on setup and wires commands
  },

  -- LSP: Tinymist (diagnostics, hover, completion, formatter)
  -- {
  --   "neovim/nvim-lspconfig",
  --   ft = "typst",
  --   config = function()
  --     require("lspconfig").tinymist.setup{
  --       -- If tinymist is not on PATH, uncomment and set the absolute path:
  --       -- cmd = { "C:\\Users\\<you>\\AppData\\Local\\bin\\tinymist.exe" },
  --       settings = {
  --         exportPdf   = "onType",                   -- or "onSave"/"never"
  --         outputPath  = "$root/target/$dir/$name",  -- where PDFs go
  --         formatterMode = "typstyle",               -- built-in formatter
  --         -- semanticTokens = "disable",            -- toggle if highlighting looks odd
  --       },
  --     }
  --   end,
  -- },
}