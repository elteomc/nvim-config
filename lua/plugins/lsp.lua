return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    lazy = true,
    config = true,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    priority = 50,
    config = function()
      require("angelo.lsp").setup()
    end,
  },
}
