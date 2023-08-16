--== Neovide settings ==--
if vim.g.neovide then
  vim.g.default_font_size = 13

  local function update_font(new_size)
    vim.g.font_size = new_size
    vim.o.guifont = "Iosevka_NF_Light:h" .. vim.g.font_size
    vim.defer_fn(function()
      print("Font size: " .. vim.g.font_size .. "pt")
    end, 400)
  end

  vim.g.neovide_refresh_rate = 165 -- Butter smooth perfection
  vim.g.neovide_hide_mouse_when_typing = false
  vim.g.neovide_remember_window_size = true

  vim.keymap.set("n", "<C-=>", function()
    update_font(vim.g.font_size + 1)
  end, { noremap = true })
  vim.keymap.set("n", "<C-->", function()
    update_font(vim.g.font_size - 1)
  end, { noremap = true })
  vim.keymap.set("n", "<C-0>", function()
    update_font(vim.g.default_font_size)
  end, { noremap = true })

  if not vim.g.font_size then
    update_font(vim.g.default_font_size)
  end
end
