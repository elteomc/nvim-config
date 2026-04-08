return {
  -- Type Git
  -- { "tpope/vim-fugitive" },
  -- {
  --   "nvim-telescope/telescope.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   config = function()
  --     local t = require("telescope.builtin")

  --     vim.keymap.set("n", "<leader>gs", t.git_status, { desc = "Git status" })
  --     vim.keymap.set("n", "<leader>gc", t.git_commits, { desc = "Git commits" })
  --     vim.keymap.set("n", "<leader>gC", t.git_bcommits, { desc = "Buffer commits" })
  --     vim.keymap.set("n", "<leader>gb", t.git_branches, { desc = "Git branches" })
  --   end
  -- },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true,
      current_line_blame_opts = { delay = 600 },
    },
    keys = function()
      local gs = require("gitsigns")

      return {
        { "]h", gs.next_hunk, desc = "Next hunk" },
        { "[h", gs.prev_hunk, desc = "Prev hunk" },
        { "<leader>hs", gs.stage_hunk, desc = "Stage hunk" },
        { "<leader>hr", gs.reset_hunk, desc = "Reset hunk" },
        { "<leader>hp", gs.preview_hunk, desc = "Preview hunk" },
        { "<leader>hb", gs.toggle_current_line_blame, desc = "Toggle blame" },
      }
    end
  },
  -- See Git
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview open" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diffview close" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" }
    },
  },
  -- {
  --   "sindrets/diffview.nvim",
  --   config = function()
  --     vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diffview open" })
  --     vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewClose<cr>", { desc = "Diffview close" })
  --     vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history" })
  --   end
  -- },
  -- Do Git
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    keys = {
      { "<leader>gg", function() require("neogit").open() end, desc = "Neogit" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      -- "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("neogit").setup({ integrations = { diffview = true } })
    end
  },
  -- {
  --   "akinsho/git-conflict.nvim",
  --   version = "*",
  --   config = function()
  --     require("git-conflict").setup()
  --   end
  -- },
}
