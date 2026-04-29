return {
  -- colors
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority=99,
    config = function()
      -- choose one variant: 'tokyonight' or '-storm', '-moon', '-night', '-day'
      -- vim.cmd.colorscheme('tokyonight-storm')
    end
  },
  {
    'rebelot/kanagawa.nvim',
    lazy = true,
    priority=97,
    init = function() vim.g.kanagawa_variant = 'dragon' end
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = true,
    priority=96,
    init = function() vim.g.catppuccin_flavour = 'macchiato' end
  },
  { 'morhetz/gruvbox' }, -- By default, plugins have 0 priority and lazy = true
  {
    'craftzdog/solarized-osaka.nvim',
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
      vim.cmd.colorscheme('solarized-osaka')
    end
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 99,
    config = function()
      require("cyberdream").setup({
        transparent = true,
        terminal_colors = true,
      })
      -- Default colorscheme stays solarized-osaka (above). Use :Switch or :colorscheme cyberdream.
    end,
  },
  {
    'nyoom-engineering/oxocarbon.nvim',
    -- lazy = true,
    event = "VeryLazy",
    priority=98,
    config = function()
      -- vim.cmd.colorscheme('oxocarbon')
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "oxocarbon",
        callback = function()
          -- no built-in transparent flag, so do it manually
          vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })
        end,
      })
    end
  },
  -- statusline
  { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function() require('lualine').setup({}) end },
  -- -- quick colorscheme picker
  -- { 'nvim-lua/plenary.nvim', lazy = true, config = function()
  --     vim.api.nvim_create_user_command('Switch', function()
  --       local list = vim.fn.getcompletion('', 'color')
  --       vim.ui.select(list, { prompt = 'Pick a colorscheme' }, function(choice)
  --         if choice then pcall(vim.cmd.colorscheme, choice) end
  --       end)
  --     end, {})
  --     pcall(vim.cmd.colorscheme, 'tokyonight')
  --     vim.keymap.set('n', '<F2>', ':Switch<CR>', { silent = true })
  --   end
  -- },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      direction = "float", -- float | horizontal | vertical | tab
      open_mapping = [[<C-\>]],
      shade_terminals = false,
    },
    keys = {
      { "<leader>to", "<cmd>ToggleTerm<cr>", desc = "Terminal toggle" },
      {
        "<leader>ca",
        function()
          require("angelo.cursor").toggle_agent()
        end,
        desc = "Cursor Agent",
      },
    },
  },
  {
      "folke/which-key.nvim",
      event = "VeryLazy",
  },
  -- vertical lines
  {
    "echasnovski/mini.indentscope",
    version = false,
    opts = {
        symbol = "|",
        options = { try_as_border = true },
    },
  }
}
