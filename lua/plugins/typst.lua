return {
  -- (tiny) filetype + :TypstWatch
  { "kaarmu/typst.vim", ft = "typst" },

  -- Fast web/SVG preview with cross-jump (Tinymist-powered)
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    opts = function()
      local deps = {}
      local la = os.getenv("LOCALAPPDATA")
      if la and la ~= "" then
        deps["tinymist"] = la .. "\\typst_nv\\tinymist.exe"
      end
      return {
        dependencies_bin = deps,
        port = 5523,
      }
    end,
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
