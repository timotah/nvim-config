vim.diagnostic.config({
  virtual_lines = {
    current_line = true
  },
  -- virtual_text = {
  --   spacing = 4,
  --   current_line = false,
  --   prefix = '●', -- Could be '●', '▎', 'x', etc.
  -- },
})

vim.lsp.set_log_level("warn")
