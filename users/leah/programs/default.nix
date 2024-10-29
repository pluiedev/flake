{
  config,
  pkgs,
  lib,
  inputs,
  inputs',
  ...
}:
{
  imports = [
    ./1password
    ./discord
    ./fcitx5
    ./firefox
    ./ghostty
    ./nvim
    ./rust
    #./virt-manager
  ];

  hm.imports = [ inputs.nix-index-database.hmModules.nix-index ];

  hm.home.packages = with pkgs; [
    # Apps
    inputs'.blender-bin.packages.default
    chromium
    gimp
    inkscape-with-extensions
    vlc

    # Command-line apps
    just
    fastfetch
    nix-output-monitor
    nurl
    xclip

    (inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix).config.build.wrapper
  ];

  programs = {
    gamemode.enable = true;
    localsend.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      remotePlay.openFirewall = true;
    };
    nix-ld.enable = true;
  };

  hm.programs = {
    bat = {
      enable = true;
      config = {
        map-syntax = [ "flake.lock:JSON" ];
      };
      syntaxes = {
        just = {
          src = lib.cleanSourceWith {
            filter =
              name: type:
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

    gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };

    git = {
      enable = true;
      userName = config.roles.base.fullName;
      userEmail = "hi@pluie.me";

      signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC7uJGE2/25M4a3DIVxtnTA5INqWsFGw+49qHXaN/kqy";
      signingFormat = "ssh";

      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        url."https://github.com/".insteadOf = "gh:";
      };
    };

    hyfetch = {
      enable = true;
      settings = {
        preset = "lesbian";
        mode = "rgb";
        lightness = 0.6;
        color_align.mode = "horizontal";
        backend = "fastfetch";
      };
    };

    nix-index-database.comma.enable = true;

    obs-studio.enable = true;
    ripgrep.enable = true;

    starship = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };
  };
}
