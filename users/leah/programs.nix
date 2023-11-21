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
    blender_3_6
    chromium
    gimp-with-plugins
    inkscape-with-extensions
    kdenlive
    libreoffice-qt
    prismlauncher
    thunderbird
    vlc

    # Command-line apps
    any-nix-shell
    comma
    just
    xclip

    # Java stuff
    jetbrains.idea-community
    jdk17
    glfw
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

    nix-index.enable = true;
    obs-studio.enable = true;
    ripgrep.enable = true;

    starship = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };

    thunderbird = {
      enable = true;
      profiles.${config.roles.base.username}.isDefault = true;
    };
  };
}
