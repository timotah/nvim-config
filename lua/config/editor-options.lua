-- import any user commands in other utils here
require("utils.reload_lsps")
-- set initial neovim configs such as tab/spaces
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set colorcolumn=80")


vim.cmd.colorscheme "catppuccin-mocha"
vim.opt.termguicolors = true
-- any commands that you want to have a short to, add <leader>
vim.g.mapleader = " "

-- line numbers
vim.opt.relativenumber = true
-- Enable absolute line numbers -- changes 0 on the current line to the actual line number
vim.opt.number = true
vim.opt.cursorline = true
vim.o.autoread = true


-- SET KEYMAPS HERE
vim.keymap.set('t', '<Esc>', '<C-\\><C-N>', { desc = 'Exit terminal mode' })
vim.keymap.set("n", "<C-e>", "<cmd>Oil<CR>", { desc = "Open Oil" })
-- ensures ctrl c works like esc in insert mode
vim.keymap.set({ "i", "v" }, "<C-c>", "<Esc>", { desc = "Exit insert/visual mode" })
-- allow for copying to sys clipboard
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabnext<CR>", { desc = "Copy to system clipboard" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Copy to system clipboard" })

-- conform keymaps
vim.keymap.set("n", "<leader>cf", function()
  require("conform").format({async = true})
end, {desc = "Format File"})

vim.keymap.set("v", "<leader>cf", function()
  require("conform").format({ async = true }, function(err)
    if not err then
      local mode = vim.api.nvim_get_mode().mode
      if vim.startswith(string.lower(mode), "v") then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
      end
    end
  end)
end, { desc = "Format code" })

-- copilot keymap redo
vim.keymap.set('i', '<C-J>', 'copilot#Accept(\"\\<CR>\")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true

-- dd in a quickfix/location window drops that entry, so a review list can be
-- burned down as you work it. The qf filetype covers both windows, so check
-- which one we are in before editing the wrong list.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("qf_drop_entry", { clear = true }),
  pattern = "qf",
  callback = function(ev)
    vim.keymap.set("n", "dd", function()
      local win = vim.fn.win_getid()
      local is_loclist = vim.fn.getwininfo(win)[1].loclist == 1
      local items = is_loclist and vim.fn.getloclist(win) or vim.fn.getqflist()
      if #items == 0 then
        return
      end

      local idx = vim.fn.line(".")
      table.remove(items, idx)

      -- dict form keeps the list title; setqflist(items, "r") would drop it
      if is_loclist then
        vim.fn.setloclist(win, {}, "r", { items = items })
      else
        vim.fn.setqflist({}, "r", { items = items })
      end

      -- replacing the list resets the cursor to line 1, so put it back
      vim.fn.cursor(math.min(idx, math.max(#items, 1)), 1)
    end, { buffer = ev.buf, desc = "Drop entry from quickfix/location list" })
  end,
})
