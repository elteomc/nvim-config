return {
  {
    "David-Kunz/gen.nvim",
    cmd = { "Gen" },
    opts = {
      model = "qwen3:8b",
      host = "localhost",
      port = "11434",
      display_mode = "float", -- alternatives: "split", "horizontal-split", "vertical-split", "float"
      show_prompt = false,
      show_model = true,
      result_filetype = "markdown",
      debug = false,
    },
    config = function(_, opts)
      require("gen").setup(opts)

      vim.keymap.set({ "n", "v" }, "<Leader>ai", ":Gen<CR>", {
        desc = "Ask local Qwen via Ollama",
      })

      vim.keymap.set("v", "<Leader>ae", ":Gen Explain_Code<CR>", {
        desc = "Explain selected code",
      })

      vim.keymap.set("v", "<Leader>af", ":Gen Fix_Code<CR>", {
        desc = "Fix selected code",
      })

      vim.keymap.set("n", "<Leader>ac", ":Gen Chat<CR>", {
        desc = "Continue Gen chat",
      })
    end,
  },
}
