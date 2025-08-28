return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
		auto_install = true,
		highlight = { enable = true, additional_vim_regex_highlighting = false },
		indent = { enable = true },
	},
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-context",
			opts = {
        mutliline_threshold = 3,
				mode = "cursor",
			},
			config = function()
				vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = false })
				vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", { underline = false })
			end,
		},
	},
	-- config = function()
	--   local config = require('nvim-treesitter.configs')
	--   config.setup({
	--     auto_install = true,
	--     highlight = { enable = true, additional_vim_regex_highlighting = false },
	--     indent = { enable = true }
	--   })
	-- end
}
