local util = require("util")
local builtin = require("telescope.builtin")

require("telescope").setup({
	defaults = {
		vimgrep_arguments = {
			"rg",
			"-L",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
		},
		prompt_prefix = "   ",
		selection_caret = "  ",
		entry_prefix = "  ",
		initial_mode = "insert",
		selection_strategy = "reset",
		sorting_strategy = "ascending",
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				prompt_position = "top",
				preview_width = 0.55,
				results_width = 0.8,
			},
			vertical = {
				mirror = false,
			},
			width = 0.87,
			height = 0.80,
			preview_cutoff = 120,
		},
		file_sorter = require("telescope.sorters").get_fuzzy_file,
		file_ignore_patterns = { "node_modules" },
		generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
		path_display = { "truncate" },
		winblend = 0,
		border = {},
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		color_devicons = true,
		set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
		qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
		-- Developer configurations: Not meant for general override
		buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
		mappings = {
			n = { ["q"] = require("telescope.actions").close },
		},
	},
})

util.register_keymap({
	n = {
		["<leader>ff"] = { builtin.find_files, desc = "Find files" },
		["<leader>fw"] = { builtin.live_grep, desc = "Live grep" },
		["<leader>fb"] = { builtin.buffers, desc = "Find buffers" },
		["<leader>fh"] = { builtin.help_tags, desc = "Help page" },
		["<leader>fo"] = { builtin.oldfiles, desc = "Find oldfiles" },
		["<leader>fz"] = { builtin.current_buffer_fuzzy_find, desc = "Find in current buffer" },
		["<leader>cm"] = { builtin.git_commits, desc = "Git commits" },
		["<leader>gt"] = { builtin.git_status, desc = "Git status" },
		["<leader>ma"] = { builtin.marks, desc = "telescope bookmarks" },

		["<leader>fa"] = {
			function()
				builtin.find_files({ follow = true, no_ignore = true, hidden = true })
			end,
			desc = "Find all",
		},
	},
})
