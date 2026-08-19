-- lua/plugins/luasnip.lua
return {
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets", -- optional but very handy
    },
    config = function()
      local ls = require("luasnip")

      ls.filetype_extend("plaintex", { "tex" })

      ls.config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = true,
        store_selection_keys = "<Tab>",
      })

      -- Load community snippets (optional)
      require("luasnip.loaders.from_vscode").lazy_load({
        exclude = { "lean" },
      })

      -- Load your own snippets from lua/snippets/
      require("luasnip.loaders.from_lua").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
      })

      -- Useful keymaps (optional since cmp Tab already handles jump/expand)
      vim.keymap.set({ "i", "s" }, "<C-l>", function()
        if ls.choice_active() then ls.change_choice(1) end
      end, { desc = "LuaSnip next choice" })
    end,
  },
}
