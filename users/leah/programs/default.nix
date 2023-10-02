{pkgs, ...}: {
  imports = [
    ./firefox.nix
    ./nvim
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
    nvd
    xclip

    # Misc
    krunner-nix

    (pkgs.makeAutostartItem {
      name = "1password";
      package = pkgs._1password-gui;
    })
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
