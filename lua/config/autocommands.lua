-- resize nvim when window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("resize_windows", { clear = true }),
  pattern = "*",
  command = "wincmd =",
})

-- dynamic line numbers
vim.api.nvim_create_autocmd('InsertEnter', {
  group = vim.api.nvim_create_augroup('NumberToggleInsertEnter', { clear = true }),
  callback = function()
    vim.opt.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd('InsertLeave', {
  group = vim.api.nvim_create_augroup('NumberToggleInsertLeave', { clear = true }),
  callback = function()
    vim.opt.relativenumber = true
  end,
})

-- autocommand for diagnostics
-- vim.api.nvim_create_autocmd("ModeChanged", {
--   pattern = ":iNormal",
--   callback = function()
--     vim.lsp.buf.publish_diagnostics()
--   end,
-- })
