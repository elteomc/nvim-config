if vim.loader then vim.loader.enable() end

vim.g.mapleader, vim.g.maplocalleader = ' ', ' '

pcall(require, "jaze.local")

-- no background color for the main background of neovim
-- vim.cmd("highlight Normal guibg=NONE")

require("jaze.settings")
require("jaze.keymaps")
require("jaze.workflow").setup()
require("jaze.cursor").setup()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  ui = {
    border = "rounded",
  },
  pkg = {
    sources = {
      "lazy",
      "packspec",
    },
  },
  rocks = {
    enabled = false,
  },
})
