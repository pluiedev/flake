require("mini.comment").setup({
	mappings = {
		comment_line = "<leader>/",
		comment_visual = "<leader>/",
	},
})
local files = require("mini.files")
files.setup({
	mappings = {
		go_in = "<CR>",
		go_in_plus = "<S-CR>",
		go_out = "<ESC>",
		go_out_plus = "<S-ESC>",
	},
})
require("mini.indentscope").setup({
	draw = { delay = 20 }, -- near-instant draw
})
require("mini.pairs").setup({})
require("mini.starter").setup({})
require("mini.surround").setup({})

local util = require("util")

util.register_keymap({
	n = {
		["<leader><leader>"] = {
			function()
				if not files.close() then
					files.open()
				end
			end,
			desc = "Open file manager",
		},
	},
})
