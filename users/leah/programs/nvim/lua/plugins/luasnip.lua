local luasnip = require "luasnip"

luasnip.config.set_config {
  history = true,
  updateevents = "TextChanged,TextChangedI",
}

-- vscode format
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.vscode_snippets_path or "" }

-- snipmate format
require("luasnip.loaders.from_snipmate").load()
require("luasnip.loaders.from_snipmate").lazy_load { paths = vim.g.snipmate_snippets_path or "" }

-- lua format
require("luasnip.loaders.from_lua").load()
require("luasnip.loaders.from_lua").lazy_load { paths = vim.g.lua_snippets_path or "" }

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] and not luasnip.session.jump_active then
      luasnip.unlink_current()
    end
  end,
})
