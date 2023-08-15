{
  user,
  pkgs,
  ...
}: {
  imports = [
    ./firefox.nix
    ./nvim
  ];

  home.packages = with pkgs; [
    # Apps
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    gimp-with-plugins
    inkscape-with-extensions
    kdenlive
    libsForQt5.kcalc
    libreoffice-qt
    mongodb-compass
    prismlauncher
    vlc

    # Coding utilities
    alejandra
    any-nix-shell
    black
    clang_16
    (ghc.withPackages (hs:
      with hs; [
        haskell-language-server
      ]))
    lua-language-server
    mold
    nil
    nodePackages_latest.nodejs
    nodePackages_latest.pnpm
    nodePackages_latest.pyright
    prettierd
    python3Full
    ruff
    ruff-lsp
    shfmt
    stylua
    taplo
    tree-sitter

    # Command-line apps
    just
    neovide
    nvd
    nvimpager
    xclip
  ];

  programs = {
    exa = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    hyfetch = {
      enable = true;
      settings = {
        preset = "lesbian";
        mode = "rgb";
        lightness = 0.60;
        color_align.mode = "horizontal";
      };
    };

    obs-studio.enable = true;
    ripgrep.enable = true;

    thunderbird = {
      enable = true;
      profiles.${user.name}.isDefault = true;
    };
  };
}
