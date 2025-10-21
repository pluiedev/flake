{
  inputs,
  pkgs,
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
    nekoray = {
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
      direnv = {
        enable = true;
        integrations = {
          fish.enable = true;
          nix-direnv.enable = true;
        };
      };
      obs-studio.enable = true;
    };

    ext.programs = {
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

      moar = {
        enable = true;
        settings = {
          no-statusbar = true;
          wrap = true;
        };
      };
    };
  };
}
