{pkgs, ...}: {
  imports = [
    ./_1password
    ./discord
    ./fish
    ./firefox
    ./gtk
    ./hyprland
    ./nvim
    #./plasma
    ./qt
    ./rust
  ];

  home.packages = with pkgs; [
    # Apps
    gimp-with-plugins
    inkscape-with-extensions
    kdenlive
    libreoffice-qt
    prismlauncher
    vlc

    # Command-line apps
    any-nix-shell
    just
    xclip

    # Misc
    krunner-nix
  ];
  programs = {
    eza = {
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
