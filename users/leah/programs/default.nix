{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./1password.nix
    ./discord
    ./fcitx5.nix
    ./firefox
    ./fish.nix
    ./ghostty.nix
    ./helix.nix
    ./vcs.nix
    ./steam.nix

    inputs.nix-index-database.nixosModules.nix-index
  ];

  programs = {
    localsend.enable = true;
    nix-index-database.comma.enable = true;
    throne = {
      enable = true;
      tunMode.enable = true;
    };
  };

  hjem.users.leah = {
    packages = with pkgs; [
      # Apps
      prismlauncher
      vlc
      thunderbird
      telegram-desktop
      inkscape
      fractal
      papers
      wechat

      (pkgs.makeAutostartItem {
        name = "throne";
        inherit (config.programs.throne) package;
      })

      # Command-line apps
      just
      nix-output-monitor
      ripgrep
      starship
      wl-clipboard
      gamescope
      xdg-terminal-exec
      eza
    ];

    rum.programs = {
      direnv.enable = true;
      starship = {
        enable = true;
        settings = lib.importTOML ./starship.toml;
        transience.enable = true;
      };
      obs-studio.enable = true;
    };

    ext.programs = {
      hyfetch = {
        enable = true;
        settings = {
          preset = "lesbian";
          mode = "rgb";
          auto_detect_light_dark = true;
          light_dark = "dark";
          pride_month_disable = false;
          lightness = 0.6;
          color_align.mode = "horizontal";
          args = null;
          distro = null;
          backend = "fastfetch";
        };
      };

      moor = {
        enable = true;
        settings = {
          no-statusbar = true;
          wrap = true;
        };
      };
    };
  };
}
