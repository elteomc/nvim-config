-- after/ftplugin/typst.lua

-- Advertise cmp capabilities to tinymist
local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = ok_cmp and cmp_lsp.default_capabilities() or {}

-- Start/enable tinymist for Typst buffers using the new API
vim.lsp.config("tinymist", {
  cmd = { "C:\\Users\\angel\\AppData\\Local\\typst_nv\\tinymist.exe" }, -- or full path
  filetypes = { "typst" },
  capabilities = capabilities,
  settings = {
    exportPdf     = "onType",
    outputPath    = "$root/target/$dir/$name",
    formatterMode = "typstyle",
    compilerPath  =
    "C:\\Users\\angel\\AppData\\Local\\Microsoft\\WinGet\\Packages\\Typst.Typst_Microsoft.Winget.Source_8wekyb3d8bbwe\\typst-x86_64-pc-windows-msvc\\typst.exe",
  },
})
vim.lsp.enable({ "tinymist" })

-- Buffer-local keymaps (only in .typ buffers)
local function map(mode, lhs, rhs, opts)
  opts = vim.tbl_extend("force", { silent = true, buffer = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

map("n", "<leader>tp", ":TypstPreviewToggle<CR>", { desc = "Typst preview" })
map("n", "<leader>tf", function() vim.lsp.buf.format({ async = false }) end,
  { desc = "Format (Tinymist/typstyle)" })

-- Pin current buffer as the main file for tinymist
map("n", "<leader>tm", function()
  local uri = vim.uri_from_fname(vim.api.nvim_buf_get_name(0))
  vim.lsp.buf.execute_command({
    command = "tinymist.pinMain",
    arguments = { uri },
  })
end, { desc = "Tinymist: Pin main" })

-- Let native LSP (tinymist) own diagnostics; avoid duplicates from coc.nvim
vim.b.coc_enabled = 0

-- Format on save for this buffer only
local grp = vim.api.nvim_create_augroup("TypstFormatOnSave", { clear = false })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = grp,
  buffer = 0, -- current typst buffer
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Typst-only cmp setup (buffer-local)
local ok_cmp2, cmp = pcall(require, "cmp")
if ok_cmp2 then
  vim.opt.completeopt = { "menu", "menuone", "noselect" } -- nicer popup behavior
  cmp.setup.buffer({
    sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "latex-symbols", option = { strategy = 0 } },
      { name = "path" },
      { name = "buffer" },
    },
    mapping = cmp.mapping.preset.insert({
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<Tab>"] = cmp.mapping(function(callback)
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        elseif require("luasnip").expand_or_jumpable() then
          require("luasnip").expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(callback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        elseif require("luasnip").jumpable(-1) then
          require("luasnip").jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
  })
end

-- autopairing the '$' only for typst files
local ok_ap, npairs = pcall(require, "nvim-autopairs")
if ok_ap then
  local Rule = require("nvim-autopairs.rule")
  npairs.add_rules({
    Rule("$", "$", { "typst" }),
  })
end

-- Visual comfort for prose/math notes
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.spell = true
vim.opt_local.conceallevel = 1
vim.opt_local.textwidth = 0

-- Move by visual line, not hard line
map("n", "j", "gj", { desc = "Visual down" })
map("n", "k", "gk", { desc = "Visual up" })
