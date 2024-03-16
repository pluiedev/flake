{pkgs, ...}: let
  tree-sitter-just = pkgs.tree-sitter.buildGrammar {
    language = "just";
    version = "0-unstable-20240311";
    src = pkgs.fetchFromGitHub {
      owner = "IndianBoy42";
      repo = "tree-sitter-just";
      rev = "5fe40d3622042c66465c4673b209a71e8376f902";
      hash = "sha256-Mw8lDpQHpI/L0p1qQYsycGT7ExMMFuYPjrb2Jbsyowo=";
    };
  };

  nvim-treesitter' = let
    inherit (pkgs.vimPlugins) nvim-treesitter;
  in
    nvim-treesitter.withPlugins (
      _: nvim-treesitter.allGrammars ++ [tree-sitter-just]
    );

  # TODO: upstream
  format-on-save = pkgs.vimUtils.buildVimPlugin {
    pname = "format-on-save.nvim";
    version = "0-unstable-20231104";
    src = pkgs.fetchFromGitHub {
      owner = "elentok";
      repo = "format-on-save.nvim";
      rev = "b7ea8d72391281d14ea1fa10324606c1684180da";
      hash = "sha256-y5zAZRuRIQEh6pEj/Aq5+ah2Qd+iNzbZgC5Z5tN1MXw=";
    };
    meta.homepage = "https://github.com/elentok/format-on-save.nvim";
  };

  luaConf = plugin: filename:
    if !builtins.isPath ./lua/plugins/${filename}.lua
    then throw "Config for ${filename} not found at ./lua/plugins/${filename}.lua"
    else {
      inherit plugin;
      type = "lua";
      config = "require 'plugins.${filename}'";
    };
in {
  hm.programs.neovim.plugins = with pkgs.vimPlugins; [
    # UI
    (luaConf catppuccin-nvim "catppuccin")
    (luaConf lualine-nvim "lualine")
    (luaConf barbar-nvim "barbar")

    # Formatting
    (luaConf format-on-save "format-on-save")

    # Completion
    (luaConf nvim-cmp "cmp")
    cmp-buffer
    cmp-nvim-lsp
    cmp-nvim-lua
    cmp-path

    # Snippets
    (luaConf luasnip "luasnip")
    cmp_luasnip
    friendly-snippets

    # Rust
    (luaConf rust-vim "rust")
    (luaConf crates-nvim "crates")
    rustaceanvim

    # LSP
    (luaConf nvim-lspconfig "lspconfig")

    # Syntax highlighting
    (luaConf nvim-treesitter' "tree-sitter")

    # File browser
    (luaConf neo-tree-nvim "neo-tree")
    nvim-web-devicons
    nui-nvim

    # Telescope
    (luaConf telescope-nvim "telescope")

    # Utilities
    (luaConf mini-nvim "mini")
    (luaConf gitsigns-nvim "gitsigns") # Git status display
    (luaConf nvim-colorizer-lua "colorizer") # Highlight color codes like #21df47
    plenary-nvim # Common library for a lot of plugins

    # Keymap display
    (luaConf which-key-nvim "which-key")
  ];
}
