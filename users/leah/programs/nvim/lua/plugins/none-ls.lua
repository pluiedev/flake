local null_ls = require("null-ls")

local formatting = null_ls.builtins.formatting
local completion = null_ls.builtins.completion
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	sources = {
		--    formatting.remark,
		--    formatting.rustywind,
		--    formatting.shellharden,
		--    formatting.shfmt,
		--    formatting.sqlfluff.with {
		--      extra_args = { "--dialect", "postgres" },
		--    },
		--    formatting.stylelint,
		formatting.treefmt.with({
        -- treefmt requires a config file
        condition = function(utils)
            return true
            --return utils.root_has_file("treefmt.toml")
        end,
    }),
		--
		--    completion.spell,
		--
		--    diagnostics.codespell,
		--    diagnostics.commitlint,
		--    diagnostics.fish,
		--    diagnostics.markdownlint_cli2,
		--    diagnostics.proselint,
		--    diagnostics.selene,
		--    diagnostics.statix,
		diagnostics.todo_comments,
		diagnostics.trail_space,
		--    diagnostics.yamllint,
		--    diagnostics.zsh,
	},
})
