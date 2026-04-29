return {
  {
    "quarto-dev/quarto-nvim",
    ft = { "quarto" },
    dependencies = {
      "jmbuhr/otter.nvim", -- required by quarto-nvim (LSP in code cells)
      "neovim/nvim-lspconfig",
    },
    config = function()
      local langs = { "julia", "python", "bash", "r" }

      require("quarto").setup({
        lspFeatures = {
          enabled = true,
          languages = langs,
          chunks = "curly",
          diagnostics = {
            enabled = true,
          },
          completion = {
            enabled = true,
          },
        },
        codeRunner = {
          enabled = true,
          default_method = "molten",
        },
      })

      -- local keymaps
      local runner = require("quarto.runner")

      vim.keymap.set("n", "<Leader>rc", runner.run_cell, { desc = "Quarto: run cell" })
      vim.keymap.set("n", "<Leader>ru", runner.run_above, { desc = "Quarto: run cells above" })
      vim.keymap.set("n", "<Leader>ra", runner.run_all, { desc = "Quarto: run all cells" })
      vim.keymap.set("n", "<Leader>rm", ":MoltenInit<CR>", { desc = "Molten init" })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "quarto",
        callback = function()
          require("otter").activate(langs)
        end,
      })
    end,
  },
  {
    "benlubas/molten-nvim",
    build = ":UpdateRemotePlugins" -- interactive cell execution
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown", "quarto" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown", "quarto" }
      vim.g.mkdp_preview_options = {
        disable_filename = 0,
        sync_scroll_type = "middle",
        math = { enable = true },
      }
    end,
  },
}
