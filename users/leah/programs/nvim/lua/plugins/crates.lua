local util = require("util")
local crates = require("crates")

crates.setup({})
crates.show()

util.register_keymap({
	n = {
		["<leader>cru"] = { crates.upgrade_all_crates, desc = "Upgrade all crates" },
	},
})
