--@type ChadrcConfig
require "custom.neovide"

return {
  ui = { theme = "catppuccin" },
  plugins = "custom.plugins",
  mappings = require "custom.mappings",
}
