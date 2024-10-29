local lspconfig = require("lspconfig")

local on_attach = function(client, _)
	client.server_capabilities.documentFormattingProvider = false
	client.server_capabilities.documentRangeFormattingProvider = false
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

local default = {
	on_attach = on_attach,
	capabilities = capabilities,
}

-- See `rust.lua` for Rust configs
for k, v in pairs({
	cssls = default,
	html = default,
	jsonls = default,

	--denols = default,
	diagnosticls = default,
	graphql = default,
	ltex = default,
	lua_ls = vim.tbl_extend("force", default, {
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
					},
					maxPreload = 100000,
					preloadFileSize = 10000,
				},
			},
		},
	}),
	marksman = default,
	hls = default,
	nil_ls = default,
	pyright = default,
	quick_lint_js = default,
	ruff_lsp = default,
	svelte = default,
	taplo = default,
	ts_ls = default,
	zls = default,
}) do
	lspconfig[k].setup(v)
end
