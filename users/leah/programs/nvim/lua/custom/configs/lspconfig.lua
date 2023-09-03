local builtin = require "plugins.configs.lspconfig"
local on_attach = builtin.on_attach
local capabilities = builtin.capabilities

local lspconfig = require "lspconfig"

-- See `rust-tools.lua` for Rust configs
--
local default = {
  on_attach = on_attach,
  capabilities = capabilities,
}

for k, v in pairs {
  cssls = default,
  html = default,
  jsonls = default,

  denols = default,
  diagnosticls = default,
  graphql = default,
  ltex = default,
  marksman = default,
  hls = default,
  nixd = default,
  pyright = default,
  quick_lint_js = default,
  ruff_lsp = default,
  taplo = default,
} do
  lspconfig[k].setup(v)
end
