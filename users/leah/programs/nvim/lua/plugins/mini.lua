require("mini.comment").setup {
  mappings = {
    comment_line = "<leader>/",
    comment_visual = "<leader>/",
  },
}
require("mini.indentscope").setup {
  draw = { delay = 20 }, -- near-instant draw
}
require("mini.pairs").setup {}
require("mini.starter").setup {}
require("mini.surround").setup {}
