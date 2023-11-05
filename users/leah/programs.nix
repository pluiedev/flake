{pkgs, ...}: {
  virtualisation.docker.enable = true;

  hm.home.packages = with pkgs; [
    # Apps
    gimp-with-plugins
    inkscape-with-extensions
    kdenlive
    libreoffice-qt
    prismlauncher
    vlc
    (blender.override {
      cudaSupport = true;
    })

    # Command-line apps
    any-nix-shell
    just
    xclip
  ];
  hm.programs = {
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
