local util = require "util"

util.register_keymap {
  n = {
    ["<C-Tab>"] = {
      function()
        require("neo-tree.command").execute { toggle = true }
      end,
      desc = "Toggle neo-tree",
    },
    ["<C-n>"] = {
      function()
        require("neo-tree.command").execute { action = "focus" }
      end,
      desc = "Focus on neo-tree",
    },
  },
}
