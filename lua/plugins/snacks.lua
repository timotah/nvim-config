return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		bigfile = { enabled = false },
		dashboard = { enabled = true },
		explorer = { enabled = true },
		indent = { enabled = true },
		input = { enabled = false },
		picker = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		scope = { enabled = false },
		scroll = { enabled = false },
		statuscolumn = { enabled = true },
		words = { enabled = true },
	},
  dependencies = {
    "echasnovski/mini.icons", version = "*"
  },
  keys = {
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config Files" },
    { "<leader>fe", function() Snacks.picker.explorer() end, desc = "Open File Explorer" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
  }
}
