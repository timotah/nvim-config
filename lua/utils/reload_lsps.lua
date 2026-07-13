-- just need to import into init.lua scope
vim.api.nvim_create_user_command('LspReload', function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    for _, client in ipairs(clients) do
        vim.lsp.stop_client(client.id)
    end
    vim.defer_fn(function()
        vim.cmd("edit")
    end, 100)
end, {})
