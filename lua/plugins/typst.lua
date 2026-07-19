return {
  -- (tiny) filetype + :TypstWatch
  { "kaarmu/typst.vim", ft = "typst" },

  -- Fast web/SVG preview with cross-jump (Tinymist-powered)
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    opts = {
      port = 5523,
    },
  },
}
