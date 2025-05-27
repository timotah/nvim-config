return {
  "catppuccin/nvim",
  lazy = false,
  name = "catppucin",
  priority = 1000,
  config = function()
    vim.cmd.colorscheme "catppuccin"
  end
}

