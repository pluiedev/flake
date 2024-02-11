--@type ChadrcConfig
require "custom.neovide"

return {
  ui = {
    theme = "catppuccin",
    nvdash = {
      load_on_startup = false,

      header = {
        "                                           ",
        "     ▀███████▀    ▀███████▀                ",
        "      ▐██████      █████▀                  ",
        "      ▐██████     █████                    ",
        "       ██████    █████                     ",
        "       ██████   █████  ▄                   ",
        "       ▐█████  ████    ▀▀   ▄ ▄▄ ▄         ",
        "       ▐█████▄████    ▀██    ██ █ █        ",
        "        █████████      ██    ██ █ █        ",
        "        ███████         ▀▀  ▀▀    ▀▀       ",
        '        ██████      "Better than Emacs!"   ',
        "                                           ",
      },
    },
  },
  plugins = "custom.plugins",
  mappings = require "custom.mappings",
}
