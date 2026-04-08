-- First Search Configuration
-- return {
--   { "preservim/nerdtree", cmd = { "NERDTree", "NERDTreeToggle", "NERDTreeFind" } },
--   { "junegunn/fzf", build = nil }, -- IMPORTANT: no installer
--   { "junegunn/fzf.vim" },
-- }

return {
  {
    "stevearc/oil.nvim",
    cmd = { "Oil" },
    opts = {
      float = {
        padding = 2,
        max_width = 90,
        max_height = 30,
        border = "rounded",
        win_options = { winblend = 0 },
      },
    },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Oil: open parent directory" },
      { "<leader>o", "<cmd>Oil --float<cr>", desc = "Oil: floating window" },
    },
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "FzfLua" },
    opts = {},
    keys = {
      { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
      { "<leader>fG", "<cmd>FzfLua git_files<cr>", desc = "Git files" },
      { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Grep" },
      { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent files" },
      { "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "Help tags" },
      { "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Diagnostics (buffer)" },
      { "<leader>fD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Diagnostics (workspace)" },
      -- Check with Telescope keymaps
      { "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Git status" },
      { "<leader>gc", "<cmd>FzfLua git_commits<cr>", desc = "Git commits" },
      { "<leader>gC", "<cmd>FzfLua git_bcommits<cr>", desc = "Git commits (buffer)" },
      { "<leader>gb", "<cmd>FzfLua git_branches<cr>", desc = "Git branches" },
      -- { "<leader>gt", "<cmd>FzfLua git_stash<cr>", desc = "Git stash" },
    },
  },
}
