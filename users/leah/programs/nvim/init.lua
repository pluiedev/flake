local util = require "util"

local g = vim.g
local o = vim.o

for k, v in pairs {
  laststatus = 3,
  showmode = false,
  clipboard = "unnamedplus",
  cursorline = true,

  -- Indenting
  expandtab = true,
  shiftwidth = 2,
  smartindent = true,
  tabstop = 2,
  softtabstop = 2,

  fillchars = "eob: ",
  ignorecase = true,
  smartcase = true,
  mouse = "a",

  -- Numbers
  number = true,
  numberwidth = 2,
  ruler = false,

  signcolumn = "yes",
  splitbelow = true,
  splitright = true,
  termguicolors = true,
  timeoutlen = 400,
  undofile = true,

  -- interval for writing swap file to disk, also used by gitsigns
  updatetime = 250,

  -- disable nvim intro
  shortmess = o.shortmess .. "sI",

  -- go to previous/next line with h,l,left arrow and right arrow
  -- when cursor reaches end/beginning of line
  whichwrap = o.whichwrap .. "<>[]hl",
} do
  o[k] = v
end

g.mapleader = " "

util.register_keymap {
  n = {
    ["<C-s>"] = { ":update<CR>", desc = "Write current buffer" },
    ["<Esc>"] = { ":noh<CR>", desc = "Clear highlights" },

    ["j"] = util.wrapping_cursor("j", "Move down"),
    ["k"] = util.wrapping_cursor("k", "Move up"),
    ["<Up>"] = util.wrapping_cursor("k", "Move up"),
    ["<Down>"] = util.wrapping_cursor("j", "Move down"),

    ["gD"] = { vim.lsp.buf.declaration, desc = "LSP: Declaration" },
    ["gd"] = { vim.lsp.buf.definition, desc = "LSP: Definition" },
    ["gr"] = { vim.lsp.buf.references, desc = "LSP: References" },
    ["gi"] = { vim.lsp.buf.implementation, desc = "LSP: Implementation" },
    ["ca"] = { vim.lsp.buf.code_action, desc = "LSP: Code action" },
    ["K"] = { vim.lsp.buf.hover, desc = "LSP: Hover" },
    ["<leader>ls"] = { vim.lsp.buf.signature_help, desc = "LSP: Signature help" },
    ["<leader>D"] = { vim.lsp.buf.type_definition, desc = "LSP: Type definition" },

    ["<leader>di"] = {
      function()
        vim.diagnostic.open_float { border = "rounded" }
      end,
      desc = "Open diagnostics",
    },
  },
  i = {
    ["<C-s>"] = { "<ESC>:update<CR>gi", desc = "Write current buffer" },
  },
  v = {
    ["<Up>"] = util.wrapping_cursor("k", "Move up"),
    ["<Down>"] = util.wrapping_cursor("j", "Move down"),
  },
  x = {
    ["<Up>"] = util.wrapping_cursor("k", "Move up"),
    ["<Down>"] = util.wrapping_cursor("j", "Move down"),

    -- Don't copy the replaced text after pasting in visual mode
    -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
    ["p"] = {
      'p:let @+=@0<CR>:let @"=@0<CR>',
      desc = "Dont copy replaced text",
      silent = true,
    },
  },
}

if g.neovide then
  o.guifont = "Iosevka_NF_Light:h13"

  g.neovide_refresh_rate = 165
  g.neovide_hide_mouse_when_typing = false
  g.neovide_remember_window_size = true

  local function scale(f)
    return function() g.neovide_scale_factor = f(g.neovide_scale_factor) end
  end

  util.register_keymap {
    n = {
      ["<C-=>"] = {
        scale(function(s)
          return s * 1.25
        end),
        desc = "Neovide: Zoom in",
        noremap = true,
      },
      ["<C-->"] = {
        scale(function(s)
          return s / 1.25
        end),
        desc = "Neovide: Zoom out",
        noremap = true,
      },
      ["<C-0>"] = {
        scale(function(_)
          return 1
        end),
        desc = "Neovide: Reset zoom",
        noremap = true,
      },
    },
  }
end
