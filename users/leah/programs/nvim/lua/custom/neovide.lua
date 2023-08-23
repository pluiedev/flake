--== Neovide settings ==--
if vim.g.neovide then
  vim.o.guifont = "Iosevka_NF_Light:h13"

  -- FIXME: Fucking X11
  -- Basically, X11 hates mixed refresh rate setups (like my workstation)
  -- and causes a HUGE stutter with Neovide. The recommended fix is to set the
  -- refresh rate to the lowest denominator (60fps).
  -- I can't wait to switch to wayland.
  vim.g.neovide_refresh_rate = 60

  vim.g.neovide_hide_mouse_when_typing = false
  vim.g.neovide_remember_window_size = true

  vim.keymap.set("n", "<C-=>", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.25
  end, { noremap = true })
  vim.keymap.set("n", "<C-->", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor / 1.25
  end, { noremap = true })
  vim.keymap.set("n", "<C-0>", function()
    vim.g.neovide_scale_factor = 1
  end, { noremap = true })
end
