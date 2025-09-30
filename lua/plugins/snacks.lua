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
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "LSP Definitions" },
    { "gr", function() Snacks.picker.lsp_references() end, desc = "LSP References" },
    -- { "<leader>fs", function() Snacks.picker.lsp_document_symbols() end, desc = "LSP Document Symbols" },
    -- { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    -- { "<leader>ft", function() Snacks.picker.lsp_type_definitions() end, desc = "LSP Type Definitions" },
    -- { "<leader>fi", function() Snacks.picker.lsp_implementations() end, desc = "LSP Implementations" },
    -- { "<leader>ca", function() Snacks.picker.lsp_code_actions() end, desc = "LSP Code Actions" },
    -- { "<leader>fgb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    -- { "<leader>fgl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>fs", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config Files" },
    { "<leader>fe", function() Snacks.picker.explorer() end, desc = "Open File Explorer" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
  }
}
