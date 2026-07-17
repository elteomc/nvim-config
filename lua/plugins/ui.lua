return {
  -- colors (optional themes lazy-loaded)
  -- :Switch ensures plugins via lua/jaze/settings.lua)
  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 99,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    priority = 97,
    init = function()
      vim.g.kanagawa_variant = "dragon"
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 96,
    init = function()
      vim.g.catppuccin_flavour = "macchiato"
    end,
  },
  { "morhetz/gruvbox", lazy = true },
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 100,
    opts = {
      transparent = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
      },
    },
    config = function(_, opts)
      require("solarized-osaka").setup(opts)
      vim.cmd.colorscheme("solarized-osaka")
    end,
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = true,
    priority = 99,
    config = function()
      require("cyberdream").setup({
        transparent = true,
        terminal_colors = true,
      })
    end,
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = true,
    priority = 98,
    config = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "oxocarbon",
        callback = function()
          vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })
        end,
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({})
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      direction = "float",
      open_mapping = [[<C-\>]],
      shade_terminals = false,
    },
    keys = {
      { "<leader>to", "<cmd>ToggleTerm<cr>", desc = "Terminal toggle" },
      {
        "<leader>ca",
        function()
          require("jaze.cursor").toggle_agent()
        end,
        desc = "Cursor Agent",
      },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
  },
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = "VeryLazy",
    opts = {
      symbol = "|",
      options = { try_as_border = true },
    },
  },
}
