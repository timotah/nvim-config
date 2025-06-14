return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettier,
        -- require("none-ls.diagnostics.eslint_d"),
        -- require("none-ls.code_actions.eslint_d"),
        null_ls.builtins.formatting.black,
      },
    })

    vim.keymap.set("n", "<leader>gf", function()
      vim.lsp.buf.format({ timeout_ms = 5000 })
    end, { desc = "Format with LSP" })
  end,
}
