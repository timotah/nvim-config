return {
	"saghen/blink.cmp",
	version = "1.*",
	-- `main` is untested, please open a PR if you've confirmed it works as expected
	dependencies = { { "L3MON4D3/LuaSnip", version = "v2.*" }, { "rafamadriz/friendly-snippets" } },
	opts = {
    completion = {
      documentation = {
        auto_show = true,
      }
    },
		snippets = { preset = "luasnip" },
		-- ensure you have the `snippets` source (enabled by default)
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        lsp = {
          name = "LSP",
          enabled = true,
          async = true,
          timeout_ms = 500,
          max_items = 5,
        },
      },
		},
	},
}
