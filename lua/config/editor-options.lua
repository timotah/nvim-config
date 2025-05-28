-- set initial neovim configs such as tab/spaces
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- any commands that you want to have a short to, add <leader>
vim.g.mapleader = " "

-- line numbers
vim.opt.relativenumber = true

-- autocommand for diagnostics
-- vim.api.nvim_create_autocmd("ModeChanged", {
--   pattern = ":iNormal",
--   callback = function()
--     vim.lsp.buf.publish_diagnostics()
--   end,
-- })

vim.keymap.set("n", "<C-e>", "<cmd>Oil<CR>")
