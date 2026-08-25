local diff = require("utils.diff_pick_commit")

return {
	"sindrets/diffview.nvim",
	cmd = {
		"DiffviewOpen",
		"DiffviewClose",
		"DiffviewFileHistory",
		"DiffviewToggleFiles",
		"DiffviewFocusFiles",
		"DiffviewRefresh",
	},
	keys = {
		{ "<leader>do", "<cmd>DiffviewOpen<cr>", desc = "Diff working tree against HEAD" },
		{ "<leader>dp", "<cmd>DiffviewOpen origin/main...HEAD<cr>", desc = "Diff against HEAD - GH PR style" },
		{ "<leader>dr", diff.diff_pick_commit, desc = "Diff HEAD vs. a commit I pick" },

		{ "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (current file)" },
		{ "<leader>dH", "<cmd>DiffviewFileHistory<cr>", desc = "File history (repo)" },
		{ "<leader>dx", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },

		{
			-- diffview watches .git/index (watch_index) and refreshes on BufWritePost,
			-- but nothing watches the working tree -- so files rewritten outside nvim
			-- leave both the buffers and the panel stale. This resyncs all three layers.
			"<leader>dR",
			function()
				vim.cmd("checktime") -- reload buffers whose on-disk copy changed
				vim.cmd("DiffviewRefresh") -- re-stat panel entries from git

				-- :diffupdate acts on the current window's diff group, so run it from
				-- inside a diff window (the file panel isn't one). One call is enough.
				for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
					if vim.wo[win].diff then
						vim.api.nvim_win_call(win, function()
							vim.cmd("diffupdate")
						end)
						break
					end
				end
			end,
			desc = "Refresh diff (reload changes from disk)",
		},
		-- visual mode: trace history of selected lines
		{ "<leader>dv", ":'<,'>DiffviewFileHistory<cr>", desc = "Line history", mode = "v" },
	},
	config = function()
		require("diffview").setup({
			enhanced_diff_hl = true,
			use_icons = true,
			watch_index = true, -- auto-refresh when git index changes (e.g. after staging)
			view = {
				default = {
					winbar_info = true,
					disable_diagnostics = true, -- lsp squiggles in diff panes are noisy
				},
				merge_tool = {
					layout = "diff3_horizontal",
					winbar_info = true,
					disable_diagnostics = true,
				},
				file_history = {
					winbar_info = true,
					disable_diagnostics = true,
				},
			},
			file_panel = {
				listing_style = "tree",
				tree_options = {
					flatten_dirs = true,
					folder_statuses = "only_folded",
				},
				win_config = {
					position = "left",
					width = 35,
				},
			},
			hooks = {
				diff_buf_read = function(bufnr)
					-- keep diff panes clean
					vim.opt_local.wrap = false
					vim.opt_local.list = false
				end,
			},
		})
	end,
}
