return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-context",
			config = function()
				require("treesitter-context").setup({
					enable = true,
					max_lines = 3,
					min_window_height = 0,
					line_numbers = true,
					multiline_threshold = 3,
					trim_scope = "outer",
					mode = "cursor",
					separator = nil,
					zindex = 20,
				})
			end,
		},
	},
	config = function()
		require("nvim-treesitter").install({
			"lua",
			"vim",
			"vimdoc",
			"python",
			"javascript",
			"typescript",
			"html",
			"css",
			"json",
			"yaml",
			"markdown",
			"markdown_inline",
			"bash",
      "go",
      "c"
		})

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
			pattern = {
				"lua", "vim", "help", "python", "javascript", "typescript",
				"html", "css", "json", "yaml", "markdown", "sh", "go", "c"
			},
			callback = function(args)
				pcall(vim.treesitter.start, args.buf)
			end,
		})
	end,
}
