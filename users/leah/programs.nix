{
  config,
  pkgs,
  blender-bin,
  ...
}: {
  virtualisation.docker.enable = true;

  nixpkgs.overlays = [blender-bin.overlays.default];

  hm.home.packages = with pkgs; [
    # Apps
    gimp-with-plugins
    inkscape-with-extensions
    kdenlive
    libreoffice-qt
    prismlauncher
    vlc
    blender_3_6

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

    thunderbird = {
      enable = true;
      profiles.${config.roles.base.username} = {
        isDefault = true;
      };
    };
  };
}
