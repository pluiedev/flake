{pkgs, ...}: let
  tree-sitter-just = pkgs.tree-sitter.buildGrammar {
    language = "just";
    version = "unstable-2023-03-18";
    src = pkgs.fetchFromGitHub {
      owner = "IndianBoy42";
      repo = "tree-sitter-just";
      rev = "4e5f5f3ff37b12a1bbf664eb3966b3019e924594";
      hash = "sha256-Qs0Klt9uj6Vgs4vJrjKXYD8nNe8KYdWCnADvogm4/l0=";
    };
  };

  # TODO: upstream
  format-on-save = pkgs.buildVimPlugin {
    pname = "format-on-save.nvim";
    version = "2023-11-04";
    src = pkgs.fetchFromGitHub {
      owner = "elentok";
      repo = "format-on-save.nvim";
      rev = "b7ea8d72391281d14ea1fa10324606c1684180da";
      hash = "sha256-y5zAZRuRIQEh6pEj/Aq5+ah2Qd+iNzbZgC5Z5tN1MXw=";
    };
    meta.homepage = "https://github.com/elentok/format-on-save.nvim";
  };
in {
  hm.programs.neovim.plugins = with pkgs.vimPlugins; [
    # UI
    nvchad-ui
    catppuccin-nvim

    # Formatting
    format-on-save

    # Completion
    cmp-buffer
    cmp-nvim-lsp
    cmp-nvim-lua
    cmp-path
    nvim-cmp

    # Snippets
    luasnip
    cmp_luasnip
    friendly-snippets

    # Rust
    crates-nvim
    rust-tools

    # LSP
    nvim-lspconfig

    # Syntax highlighting
    (nvim-treesitter.withPlugins (
      _: nvim-treesitter.allGrammars ++ [tree-sitter-just]
    ))

    # File browser
    neo-tree-nvim
    nvim-web-devicons

    # Utilities
    mini-nvim # mini.{comment,autopairs,indentscope,pairs,pick,surround,starter}
    gitsigns-nvim # Git status display
    nvim-colorizer-lua # Highlight color codes like #21df47
    plenary-nvim # Utils
    which-key-nvim # Keymap
  ];
}
