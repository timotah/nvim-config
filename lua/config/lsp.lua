local capabilities = require("cmp_nvim_lsp").default_capabilities()
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

    local tele = require("telescope.builtin")
    map("gd", vim.lsp.buf.definition, "Goto Definition")
    map("<leader>fs", tele.lsp_document_symbols, "Doc Symbols")
    map("<leader>fS", tele.lsp_dynamic_workspace_symbols, "Dynamic Symbols")
    map("<leader>ft", tele.lsp_type_definitions, "Goto Type")
    -- map('<leader>fr', tele.lsp_references, 'Goto References')
    map("<leader>fi", tele.lsp_implementations, "Goto Impl")

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

-- adding hover borders for lsps, not doing it right now because of telescope weird borders
-- vim.o.winborder = "rounded"
