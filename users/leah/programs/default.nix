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
    mongodb-compass
    prismlauncher
    steam
    vlc

    # System utilities
    ffmpeg_6
    pipewire
    zerotierone
    (nerdfonts.override {fonts = ["Iosevka"];})

    # Coding utilities
    alejandra
    black
    clang_16
    deadnix
    deno
    lua-language-server
    mold
    perl
    temurin-bin
    pre-commit
    python3Full
    nodePackages_latest.nodejs
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
    zi
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
    gh.enable = true;
    hyfetch.enable = true;
    fish.enable = true;

    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        add_newline = true;
      };
    };

    obs-studio.enable = true;
    ripgrep.enable = true;

    thunderbird = {
      enable = true;
      profiles.leah.isDefault = true;
    };
  };
}
