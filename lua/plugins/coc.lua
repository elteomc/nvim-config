return {
  'neoclide/coc.nvim',
  branch = 'release',
  init = function()
    -- Don’t let CoC attach to Lean buffers; lean.nvim handles those.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "lean", "tex", "plaintex", "bib" },
      callback = function() vim.b.coc_enabled = 0 end,
    })
  end,
}
