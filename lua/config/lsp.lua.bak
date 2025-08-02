local capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.config("*", {
  capabilities = capabilities,
})
vim.lsp.enable({
  -- lua
  "lua_ls",
  -- js/ts
  "ts_ls",
  -- angularls
  "angularls",
  -- html
  "html",
  -- css
  "cssls",
  -- python
  "pyright",
  -- emmet
  "emmet_language_server"
})

local config_copy = vim.deepcopy(vim.lsp.config["angularls"])
local cmd_copy = config_copy.cmd --[[@as string[] ]]
local new_cfg = vim.list_extend(cmd_copy, { "--forceStrictTemplates" })
vim.lsp.config("angularls", {
  cmd = new_cfg,
})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "Lsp: " .. desc })
    end

    -- local tele = require("telescope.builtin")
    map("gd", vim.lsp.buf.definition, "Goto Definition")
    -- map("gr", tele.lsp_references, 'Goto References')
    -- map("<leader>fs", tele.lsp_document_symbols, "Doc Symbols")
    -- map("<leader>fS", tele.lsp_dynamic_workspace_symbols, "Dynamic Symbols")
    -- map("<leader>ft", tele.lsp_type_definitions, "Goto Type")
    -- map("<leader>fi", tele.lsp_implementations, "Goto Impl")

    map("K", function()
      vim.lsp.buf.hover({ border = "rounded" })
    end, "hover documenation")
    map("<leader>E", vim.diagnostic.open_float, "diagnostic")
    map("<leader>k", vim.lsp.buf.signature_help, "sig help")
    map("<leader>rn", vim.lsp.buf.rename, "rename")
    map("<leader>ca", vim.lsp.buf.code_action, "code action")

    vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Lsp: code_action" })
  end,
})

-- autocommand to show the lsp progress
---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= "table" then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ("[%3d%%] %s%s"):format(
            value.kind == "end" and 100 or value.percentage or 100,
            value.title or "",
            value.message and (" **%s**"):format(value.message) or ""
          ),
          done = value.kind == "end",
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(table.concat(msg, "\n"), "info", {
      id = "lsp_progress",
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and " "
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

-- adding hover borders for lsps, not doing it right now because of telescope weird borders
-- vim.o.winborder = "rounded"
