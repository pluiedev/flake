local builtin = require "plugins.configs.lspconfig"
local on_attach = builtin.on_attach
local capabilities = builtin.capabilities

return {
  server = {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "/etc/profiles/per-user/leah/bin/rust-analyzer" } -- Jank workaround
    -- Configure this properly in nix
  },
}
