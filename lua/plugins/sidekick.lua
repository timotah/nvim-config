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

		function Herdr:init()
			-- external: the session lives in herdr, never in an nvim terminal window
			self.external = true
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
			-- return nothing: no terminal window is spawned for this session
		end

		function Herdr:attach()
			-- nothing to do; text is piped straight to the herdr pane
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
										external = true,
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
		-- attach / detach (no nvim window is ever opened; the CLI lives in herdr)
		{
			"<leader>ac",
			function()
				require("sidekick.cli").show({ name = "claude" })
			end,
			desc = "Sidekick Attach Claude Code",
		},
		{
			"<leader>ao",
			function()
				require("sidekick.cli").show({ name = "opencode" })
			end,
			desc = "Sidekick Attach Opencode",
		},
		{
			"<leader>as",
			function()
				require("sidekick.cli").select()
			end,
			desc = "Sidekick Select CLI",
		},
		{
			"<leader>ad",
			function()
				require("sidekick.cli").close()
			end,
			desc = "Sidekick Detach CLI",
		},

		-- pipe context into the attached CLI's prompt (nothing is submitted)
		{
			"<leader>at",
			function()
				require("sidekick.cli").send({ msg = "{this}" })
			end,
			mode = { "n", "x" },
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
			"<leader>ab",
			function()
				require("sidekick.cli").send({ msg = "{buffers}" })
			end,
			desc = "Send Open Buffers",
		},
		{
			"<leader>aq",
			function()
				require("sidekick.cli").send({ msg = "{quickfix}" })
			end,
			desc = "Send Quickfix",
		},

		-- canned prompts, built up piece by piece
		{
			"<leader>pe",
			function()
				require("sidekick.cli").send({ prompt = "explain" })
			end,
			mode = { "n", "x" },
			desc = "Prompt: Explain",
		},
		{
			"<leader>pf",
			function()
				require("sidekick.cli").send({ prompt = "fix" })
			end,
			mode = { "n", "x" },
			desc = "Prompt: Fix",
		},
		{
			"<leader>pr",
			function()
				require("sidekick.cli").send({ prompt = "review" })
			end,
			mode = { "n", "x" },
			desc = "Prompt: Review",
		},
		{
			"<leader>pt",
			function()
				require("sidekick.cli").send({ prompt = "tests" })
			end,
			mode = { "n", "x" },
			desc = "Prompt: Tests",
		},
		{
			"<leader>pd",
			function()
				require("sidekick.cli").send({ prompt = "diagnostics" })
			end,
			desc = "Prompt: Diagnostics",
		},
		{
			"<leader>pc",
			function()
				require("sidekick.cli").send({ prompt = "changes" })
			end,
			desc = "Prompt: Review my changes",
		},

		-- send a bare newline to submit whatever has been built up
		{
			"<leader>a<cr>",
			function()
				require("sidekick.cli").send({ msg = "\n" })
			end,
			desc = "Submit built prompt",
		},
	},
}
