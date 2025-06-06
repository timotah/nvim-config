-- set initial neovim configs such as tab/spaces
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.opt.termguicolors = true
-- any commands that you want to have a short to, add <leader>
vim.g.mapleader = " "

-- line numbers
vim.opt.relativenumber = true
-- Enable absolute line numbers -- changes 0 on the current line to the actual line number
vim.opt.number = true

-- Enable relative line numbers by default

-- Autocmd to switch off relative numbers when entering Insert mode
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

vim.keymap.set("n", "<C-e>", "<cmd>Oil<CR>")
-- ensures that ctrl c replicates the same events when using it to get out of insert, usually use ctrl c on a laptop
vim.keymap.set("i", "<C-c>", "<Esc>")
