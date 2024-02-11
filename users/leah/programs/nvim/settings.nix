{
  programs.neovim.generatedConfigs.fennel = ''
    (each [k v {
      :laststatus 3
      :showmode false
      :clipboard unnamedplus
      :cursorline true

      ; Indenting
      :expandtab true
      :shiftwidth 2
      :smartindent true
      :tabstop 2
      :softtabstop 2

      :fillchars { :eob " " }
      :ignorecase true
      :smartcase true
      :mouse "a"

      ; Numbers
      :number true
      :numberwidth 2
      :ruler false

      :signcolumn "yes"
      :splitbelow true
      :splitright true
      :termguicolors true
      :timeoutlen 400
      :undofile true

      ; interval for writing swap file to disk, also used by gitsigns
      :updatetime 250
    }] (tset vim.opt k v))

    ; disable nvim intro
    (vim.opt.shortmess:append "sI")

    ; go to previous/next line with h,l,left arrow and right arrow
    ; when cursor reaches end/beginning of line
    (vim.opt.whichwrap:append "<>[]hl")

    (set vim.g.mapleader " ")
  '';
}
