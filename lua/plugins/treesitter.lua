return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    event = { "BufReadPre", "BufNewFile" },
    cmd = {
      "TSUpdate",
      "TSInstall",
      "TSUninstall",
      "TSBufEnable",
      "TSBufDisable",
      "TSModuleInfo",
    },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
          disable = function(_, buf)
            if _ == "markdown" or _ == "markdown_inline" then
              return true
            end

            return vim.api.nvim_buf_line_count(buf) > 5000
          end,
        },
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "cpp",
          "python",
          "julia",
          "haskell",
          "markdown",
          "markdown_inline",
        },
      })
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
}
