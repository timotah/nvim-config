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


-- set keymaps here

vim.keymap.set("n", "<C-e>", "<cmd>Oil<CR>")
-- ensures ctrl c works like esc in insert mode
vim.keymap.set({ "i", "v" }, "<C-c>", "<Esc>")
vim.keymap.set("v", "<leader>y", '"+y')


-- copilot keymap redo
vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true
