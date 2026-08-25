return {
	"folke/sidekick.nvim",
	event = "VeryLazy",
	config = function(_, opts)
		local Herdr = {}
		Herdr.__index = Herdr
		Herdr.priority = 50

		local function herdr_json(args)
			local out = vim.trim(vim.fn.system(vim.list_extend({ "herdr" }, args)))
			if vim.v.shell_error ~= 0 or out == "" then
				return nil
			end
			local ok, result = pcall(vim.fn.json_decode, out)
			return ok and result or nil
		end

		local function attach_cmd(self)
			if self.herdr_terminal_id then
				return { cmd = { "herdr", "terminal", "attach", self.herdr_terminal_id } }
			end
		end

		function Herdr:init()
			self.is_running = function(s)
				return s.herdr_pane_id and herdr_json({ "pane", "get", s.herdr_pane_id }) ~= nil
			end
		end

		function Herdr:start()
			local Util = require("sidekick.util")
			local r = herdr_json({ "workspace", "create", "--cwd", self.cwd, "--label", self.tool.name, "--no-focus" })
			if not (r and r.result and r.result.root_pane) then
				Util.error("herdr: failed to create workspace")
				return nil
			end

			local pid = r.result.root_pane.pane_id
			self.id = pid
			self.herdr_pane_id = pid
			self.mux_session = r.result.workspace.workspace_id
			self.started = true
			self.mux_backend = "herdr"

			local cmd = table.concat(vim.tbl_map(vim.fn.shellescape, self.tool.cmd), " ")
			herdr_json({ "pane", "run", pid, cmd })

			local pi = herdr_json({ "pane", "get", pid })
			if pi and pi.result and pi.result.pane then
				self.herdr_terminal_id = pi.result.pane.terminal_id
			end

			Util.info(("Started **%s** in herdr workspace"):format(self.tool.name))
			return attach_cmd(self)
		end

		function Herdr:attach()
			return attach_cmd(self)
		end

		function Herdr:send(text)
			if self.herdr_pane_id then
				vim.fn.system({ "herdr", "pane", "send-text", self.herdr_pane_id, text })
			end
		end

		function Herdr:submit()
			if self.herdr_pane_id then
				vim.fn.system({ "herdr", "pane", "send-keys", self.herdr_pane_id, "enter" })
			end
		end

		function Herdr.sessions()
			local tools = require("sidekick.config").tools()
			local r = herdr_json({ "pane", "list" })
			if not (r and r.result and r.result.panes) then
				return {}
			end

			local ret = {}
			local Procs = require("sidekick.cli.procs")
			local procs = Procs.new()

			for _, pane in ipairs(r.result.panes) do
				local pi = herdr_json({ "pane", "process-info", "--pane", pane.pane_id })
				if pi and pi.result and pi.result.process_info then
					local info = pi.result.process_info
					local pid = (
						info.foreground_processes
						and info.foreground_processes[1]
						and info.foreground_processes[1].pid
					) or info.shell_pid
					if pid then
						local cwd = (
							info.foreground_processes
							and info.foreground_processes[1]
							and info.foreground_processes[1].cwd
						) or pane.cwd
						procs:walk(pid, function(proc)
							for _, tool in pairs(tools) do
								if tool:is_proc(proc) then
									ret[#ret + 1] = {
										id = pane.pane_id,
										cwd = cwd,
										tool = tool,
										herdr_pane_id = pane.pane_id,
										herdr_terminal_id = pane.terminal_id,
										mux_session = pane.workspace_id,
										pids = Procs.pids(pid),
									}
									return true
								end
							end
						end)
					end
				end
			end

			return ret
		end

		if vim.fn.executable("herdr") == 1 then
			local ok, session = pcall(require, "sidekick.cli.session")
			if ok then
				session.register("herdr", Herdr)
			end
		end

		-- Validation runs inside vim.schedule() in Config.setup() —
		-- patch must stay active until that async callback fires.
		local config = require("sidekick.config")
		local _validate = config.validate
		config.validate = function(key, t)
			if key == "cli.mux.backend" then
				t = vim.list_extend(vim.deepcopy(t), { "herdr" })
			end
			return _validate(key, t)
		end
		require("sidekick").setup(opts)
		vim.schedule(function()
			config.validate = _validate
		end)
	end,
	opts = {
		-- add any options here
		nes = {
			enabled = false,
		},
		cli = {
			mux = {
				backend = "herdr",
				enabled = true,
			},
			win = {
				keys = {
					prompt = { "<a-p>", "prompt", mode = "t", desc = "insert prompt or context" },
					shift_enter = {
						"<S-CR>",
						function(terminal)
							vim.api.nvim_chan_send(terminal.job, "\x1b[13;2u")
						end,
						mode = "t",
						desc = "Send Shift+Enter to terminal application",
					},
					toggle_focus = {
						"<c-a>",
						function(terminal)
							local mode = vim.fn.mode()

							if mode == "t" then
								-- We're in terminal mode, need to switch to another window
								-- Note: wincmd("p") doesn't work from terminal mode keymaps,
								-- so we manually find and switch to a non-terminal window

								local current_win = vim.api.nvim_get_current_win()
								local all_wins = vim.api.nvim_list_wins()

								-- Find the first window that isn't the current terminal
								local target_win = nil
								for _, win in ipairs(all_wins) do
									if win ~= current_win then
										target_win = win
										break
									end
								end

								if target_win then
									-- Exit terminal mode first
									vim.cmd.stopinsert()

									-- Schedule the window switch to happen after stopinsert completes
									vim.schedule(function()
										vim.api.nvim_set_current_win(target_win)
									end)
								end
							else
								-- Already in normal mode, use the standard blur method
								terminal:blur()
							end
						end,
						mode = { "n", "t" },
						desc = "Return to editor",
					},
				},
			},
			tools = {
				claude = {
					cmd = { "claude", "--verbose", "--dangerously-skip-permissions" },
				},
				opencode = {
					cmd = { "opencode" },
					-- HACK: https://github.com/sst/opencode/issues/445
					-- env = { OPENCODE_THEME = "catppuccin" },
					env = {
						OPENCODE_CONFIG_DIR = vim.fn.expand("~/.config/opencode/"),
					},
				},
				["kiro-cli"] = {
					cmd = { "kiro-cli" },
				},
			},
		},
	},
	keys = {
		{
			"<tab>",
			function()
				-- if there is a next edit, jump to it, otherwise apply it if any
				if not require("sidekick").nes_jump_or_apply() then
					return "<Tab>" -- fallback to normal tab
				end
			end,
			expr = true,
			desc = "Goto/Apply Next Edit Suggestion",
		},
		{
			"<c-a>",
			function()
				-- This keymap is for focusing the terminal from editor buffers
				-- The reverse (terminal -> editor) is handled by sidekick's win.keys
				require("sidekick.cli").focus()
			end,
			desc = "Sidekick Focus Terminal",
			mode = { "n", "i", "x" }, -- Removed "t" mode since it's handled by sidekick
		},
		{
			"<leader>ao",
			function()
				require("sidekick.cli").toggle({ name = "opencode", focus = true })
			end,
			desc = "Sidekick Toggle Opencode",
		},
		{
			"<leader>ac",
			function()
				require("sidekick.cli").toggle({ name = "claude", focus = true })
			end,
			desc = "Sidekick Toggle Claude Code",
		},
		{
			"<leader>aa",
			function()
				require("sidekick.cli").toggle()
			end,
			desc = "Sidekick Toggle CLI",
		},
		{
			"<leader>as",
			function()
				require("sidekick.cli").select()
			end,
			-- Or to select only installed tools:
			-- require("sidekick.cli").select({ filter = { installed = true } })
			desc = "Select CLI",
		},
		{
			"<leader>ad",
			function()
				require("sidekick.cli").close()
			end,
			desc = "Detach a CLI Session",
		},
		{
			"<a-h>",
			function()
				require("sidekick.cli").hide()
			end,
			desc = "Hide a CLI Session",
			mode = { "t" },
		},
		{
			"<leader>ah",
			function()
				require("sidekick.cli").hide()
			end,
			desc = "Hide a CLI Session",
		},
		{
			"<leader>at",
			function()
				require("sidekick.cli").send({ msg = "{this}" })
			end,
			mode = { "x", "n" },
			desc = "Send This",
		},
		{
			"<leader>af",
			function()
				require("sidekick.cli").send({ msg = "{file}" })
			end,
			desc = "Send File",
		},
		{
			"<leader>av",
			function()
				require("sidekick.cli").send({ msg = "{selection}" })
			end,
			mode = { "x" },
			desc = "Send Visual Selection",
		},
		{
			"<leader>ap",
			function()
				require("sidekick.cli").prompt()
			end,
			mode = { "n", "x" },
			desc = "Sidekick Select Prompt",
		},
	},
}
