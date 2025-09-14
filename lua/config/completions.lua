-- local cmp = require("cmp")
local luasnip = require("luasnip")

-- extend filetype snippets where needed
luasnip.filetype_extend("typescript", { "javascript" })
luasnip.filetype_extend("htmlangular", { "html" })

require("luasnip.loaders.from_vscode").lazy_load() -- have to add this line to load the snippets from friendly-snippets, just gives vscode defaults
