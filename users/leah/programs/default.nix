{
  config,
  pkgs,
  lib,
  blender-bin,
  ...
}: {
  imports = [
    ./1password
    ./discord
    ./fcitx5
    ./firefox
    ./nvim
    ./rust
  ];

  virtualisation.docker.enable = true;

  nixpkgs.overlays = [blender-bin.overlays.default];

  hm.home.packages = with pkgs; [
    # Apps
    blender_3_6
    chromium
    gimp
    inkscape-with-extensions
    kdenlive
    libreoffice-qt
    prismlauncher
    thunderbird
    vlc

    # Command-line apps
    any-nix-shell
    cachix
    comma
    just
    nix-output-monitor
    nurl
    xclip

    # Java stuff
    jetbrains.idea-community
    jdk17
  ];

  programs = {
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      remotePlay.openFirewall = true;
    };
    nix-ld.enable = true;
  };

  hm.programs = {
    bat = {
      enable = true;
      config = {
        map-syntax = ["flake.lock:JSON"];
      };
      syntaxes = {
        just = {
          src = lib.cleanSourceWith {
            filter = name: type:
              lib.cleanSourceFilter name type
              && !builtins.elem (baseNameOf name) [
                "ShellScript (for Just).sublime-syntax"
                "Python (for Just).sublime-syntax"
              ];

            src = pkgs.fetchFromGitHub {
              owner = "nk9";
              repo = "just_sublime";
              rev = "352bae277961d41e2a1795a834dbf22661c8910f";
              hash = "sha256-QCp6ypSBhgGZG4T7fNiFfCgZIVJoDSoJBkpcdw3aiuQ=";
            };
          };
          file = "Syntax/Just.sublime-syntax";
        };
      };
    };
    eza = {
      enable = true;
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
