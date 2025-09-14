return {
<<<<<<< HEAD
	{
		"mason-org/mason-lspconfig.nvim",
		-- lazy = false,
		opts = {
			ensure_installed = {
				"lua_ls",
				"ts_ls",
				"angularls@17.3.1",
				"html",
				"cssls",
				"pyright",
				-- "emmet_language_server",
			},
			automatic_enable = false,
			automatic_installation = true,
		},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
		},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
=======
  {
    "mason-org/mason-lspconfig.nvim",
    -- lazy = false,
    opts = {
      ensure_installed = { "lua_ls", "ts_ls", "angularls@17.3.1", "html", "cssls", "pyright", "emmet_language_server" },
      automatic_enable = false,
      automatic_installation = true,
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      { "neovim/nvim-lspconfig", version = "v2.4.0" },
      {
        "jay-babu/mason-null-ls.nvim",
        opts = {
          ensure_installed = { "stylua", "prettier", "black" },
        },
      },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
>>>>>>> origin
}
