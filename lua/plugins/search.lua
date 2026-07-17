-- First Search Configuration
-- return {
--   { "preservim/nerdtree", cmd = { "NERDTree", "NERDTreeToggle", "NERDTreeFind" } },
--   { "junegunn/fzf", build = nil }, -- IMPORTANT: no installer
--   { "junegunn/fzf.vim" },
-- }

return {
  {
    "stevearc/oil.nvim",
    -- Eager-load so "-" / :Oil don't wait on first lazy.nvim fetch + require (~0.5–1s cold).
    lazy = false,
    priority = 70,
    cmd = { "Oil" },
    opts = {
      skip_confirm_for_simple_edits = true,
      prompt_save_on_select_new_entry = false,
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
      -- { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Grep" },
      {
        "<leader>fg",
        function()
          require("fzf-lua").live_grep({
            cwd = vim.bo.filetype == "oil"
              and require("oil").get_current_dir()
              or vim.fn.getcwd(),
          })
        end,
        desc = "Grep",
      },
      -- grep including hidden files
      {
        "<leader>fh",
        function()
          require("fzf-lua").live_grep({
            rg_opts = table.concat({
              "--column",
              "--line-number",
              "--no-heading",
              "--color=always",
              "--smart-case",
              "--hidden",
              "--glob=!**/.git/*",
            }, " "),
          })
        end,
        desc = "Grep (hidden files)",
      },
      {
        "<leader>fH",
        function()
          local config = require("fzf-lua.config")
          require("fzf-lua").live_grep({
            rg_opts = config.defaults.grep.rg_opts
              .. "--hidden --glob=!**/.git/*",
          })
        end,
        desc = "Grep (improved hidden)",
      },
      { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent files" },
      { "<leader>ft", "<cmd>FzfLua help_tags<cr>", desc = "Help tags" },
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
