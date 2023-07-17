{pkgs, ...}: {
  imports = [
    ./firefox.nix
    ./git.nix
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
    libsForQt5.kcalc
    libreoffice-qt
    mongodb-compass
    prismlauncher
    vlc

    # System utilities
    ffmpeg_6
    zerotierone

    # Fonts
    (nerdfonts.override {fonts = ["Iosevka"];})
    # Apparently to NixOS, having Old North Arabian support is more important than having Chinese or Japanese fonts. Wow.
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    lxgw-wenkai
    lxgw-neoxihei

    # Coding utilities
    alejandra
    any-nix-shell
    black
    clang_16
    deadnix
    deno
    haskellPackages.haskell-language-server
    lua-language-server
    mold
    perl
    temurin-bin
    pre-commit
    python3Full
    nodePackages_latest.nodejs
    nodePackages_latest.pnpm
    nodePackages_latest.pyright
    ruff
    ruff-lsp
    rustup
    statix
    stylua
    tree-sitter

    # Command-line apps
    just
    nethack
    nvd
    nvimpager
    starship
    tectonic
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
      nix-direnv = {
        enable = true;
      };
    };

    fzf.enable = true;
    hyfetch.enable = true;
    obs-studio.enable = true;
    ripgrep.enable = true;

    thunderbird = {
      enable = true;
      profiles.leah.isDefault = true;
    };
  };
}
