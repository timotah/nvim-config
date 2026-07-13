local M = {}

function M.diff_pick_commit()
	Snacks.picker.git_log({
		confirm = function(picker, item)
			picker:close()
			if item and item.commit then
				vim.cmd("DiffviewOpen " .. item.commit .. "..HEAD")
			end
		end,
	})
end

return M
