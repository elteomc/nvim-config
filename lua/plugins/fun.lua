-- milli.nvim: startup ASCII splash (Neovim 0.10+, termguicolors).
-- Must load before VimEnter, since `event = "UIEnter"` runs too late and skips the splash.
-- cellular-automaton.nvim: buffer animations (:CellularAutomaton ...), requires treesitter.

return {
  {
    "amansingh-afk/milli.nvim",
    lazy = false,
    config = function()
      require("milli").vimenter({ splash = "skeleton", loop = false })
    end,
  },
  {
    "eandrju/cellular-automaton.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "CellularAutomaton",
    keys = {
      {
        "<leader>fml",
        "<cmd>CellularAutomaton make_it_rain<cr>",
        desc = "Cellular automaton: make it rain",
      },
      {
        "<leader>fmg",
        "<cmd>CellularAutomaton game_of_life<cr>",
        desc = "Cellular automaton: game of life",
      },
    },
  },
}
