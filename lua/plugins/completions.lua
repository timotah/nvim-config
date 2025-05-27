return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "saadparwaiz1/cmp_luasnip", -- this is what allows you to complete the snippets chosen from LuaSnip
      "rafamadriz/friendly-snippets",
      "hrsh7th/cmp-nvim-lsp",
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-cmdline"
    }
    -- opts = function (_,opts)
    --   opts.sources = opts.sources or {}
    --   table.insert(opts.sources, {
    --     name = "lazydev",
    --     group_index = 0, -- set group index to 0 to skip loading LuaLS completions
    --   })
    -- end,
    -- config = function()
    --   local cmp = require("cmp")
    --   require("luasnip.loaders.from_vscode").lazy_load() -- have to add this line to load the snippets from friendly-snippets
    --   cmp.setup({
    --     snippet = {
    --       -- INFO- using luasnip for the snippet engine
    --       expand = function(args)
    --         require("luasnip").lsp_expand(args.body)
    --       end,
    --     },
    --     -- just customizes how the window looks
    --     window = {
    --       completion = cmp.config.window.bordered(),
    --       documentation = cmp.config.window.bordered(),
    --     },
    --     mapping = cmp.mapping.preset.insert({
    --       ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    --       ["<C-f>"] = cmp.mapping.scroll_docs(4),
    --       ["<C-Space>"] = cmp.mapping.complete(),
    --       ["<C-e>"] = cmp.mapping.abort(),
    --       ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    --     }),
    --     -- sources for the snippets
    --     sources = cmp.config.sources({
    --       { name = "nvim_lsp" }, -- this is what enables the lsp level snippets 
    --       { name = "luasnip" }, -- For luasnip users.
    --       { name = "buffer" },
    --     }),
    --   })
    --
    --   -- TIM-TODO: RESEARCH THE GITCOMMIUTMSet configuration for specific filetype.
    --   -- cmp.setup.filetype('gitcommit', {
    --   --   sources = cmp.config.sources({
    --   --         { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    --   --     }, {
    --   --         { name = 'buffer' },
    --   --     })
    --   -- })
    --
    --   -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    --   -- cmp.setup.cmdline({ '/', '?' }, {
    --   --     mapping = cmp.mapping.preset.cmdline(),
    --   --     sources = {
    --   --         { name = 'buffer' }
    --   --     }
    --   -- })
    --
    --   -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    --   -- cmp.setup.cmdline(':', {
    --   --     mapping = cmp.mapping.preset.cmdline(),
    --   --     sources = cmp.config.sources({
    --   --         { name = 'path' }
    --   --     }, {
    --   --         { name = 'cmdline' }
    --   --     })
    --   -- })
    -- end,
  },
}
