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
  hls = default,
  nil_ls = default,
  pyright = default,
  rubocop = default,
  ruff_lsp = default,
  taplo = default,
} do
  lspconfig[k].setup(v)
end
