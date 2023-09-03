{pkgs, ...}: {
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
    libreoffice-qt
    prismlauncher
    vlc

    # Coding utilities
    any-nix-shell
    clang_16
    deno
    (ghc.withPackages (hs:
      with hs; [
        haskell-language-server
      ]))
    nodePackages_latest.nodejs
    python3Full

    # Command-line apps
    just
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
  };
}
