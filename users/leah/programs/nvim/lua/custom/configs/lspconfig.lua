local builtin = require "plugins.configs.lspconfig"
local on_attach = builtin.on_attach
local capabilities = builtin.capabilities

local lspconfig = require "lspconfig"

-- See `rust-tools.lua` for Rust configs
local default = {
  on_attach = on_attach,
  capabilities = capabilities,
}

for k, v in pairs {
  cssls = default,
  html = default,
  jsonls = default,

  --denols = default,
  diagnosticls = default,
  graphql = default,
  ltex = default,
  marksman = default,
  hls = default,
  nil_ls = default,
  pyright = default,
  quick_lint_js = default,
  ruff_lsp = default,
  svelte = default,
  taplo = default,
  tsserver = vim.tbl_extend("force", default, {
    cmd = { "tsserver", "--stdio" },
  }),
} do
  lspconfig[k].setup(v)
end
