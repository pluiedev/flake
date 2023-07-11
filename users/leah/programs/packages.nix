{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Apps
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    gimp-with-plugins
    inkscape-with-extensions
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
    mold
    perl
    rbenv
    temurin-bin
    pre-commit
    python3Full
    nodePackages_latest.nodejs
    nodePackages_latest.pyright
    ruff
    rustup
    statix
    stylua

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
}
