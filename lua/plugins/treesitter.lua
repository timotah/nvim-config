return {
 'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  opts = {
    auto_install = true,
    highlight = { enable = true, additional_vim_regex_highlighting = false },
    indent = { enable = true }
  },
  -- dependencies = {
  --   'nvim-treesitter/nvim-treesitter-context',
  -- },
  -- config = function()
  --   local config = require('nvim-treesitter.configs')
  --   config.setup({
  --     auto_install = true,
  --     highlight = { enable = true, additional_vim_regex_highlighting = false },
  --     indent = { enable = true }
  --   })
  -- end
}
