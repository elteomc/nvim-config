return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    priority = 100,
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    priority = 50,
    dependencies = {
      "mason-org/mason.nvim",
    },
    config = function()
      require("jaze.lsp").setup()
    end,
  },
}
