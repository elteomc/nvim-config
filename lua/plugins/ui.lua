local transparent_groups = {
  "Normal",
  "NormalNC",
  "NormalFloat",
  "SignColumn",
  "EndOfBuffer",
}

local function apply_transparency()
  for _, group in ipairs(transparent_groups) do
    vim.api.nvim_set_hl(0, group, {
      bg = "NONE",
    })
  end
end

local transparency_group = vim.api.nvim_create_augroup(
  "JazeTransparentBackground",
  { clear = true }
)

vim.api.nvim_create_autocmd("ColorScheme", {
  group = transparency_group,
  callback = apply_transparency,
})

return {
  -- :Switch ensures plugins via lua/jaze/settings.lua
  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 99,
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    priority = 97,
    opts = {
      transparent = true,
      theme = "dragon",
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 96,
    opts = {
      flavour = "macchiato",
      transparent_background = true,
      float = {
        transparent = true,
      },
    },
  },
  { "morhetz/gruvbox", lazy = true },
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
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
      apply_transparency()
    end,
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = true,
    -- priority = 99,
    opts = {
      transparent = true,
      terminal_colors = true,
    },
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = true,
    -- priority = 98,
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
