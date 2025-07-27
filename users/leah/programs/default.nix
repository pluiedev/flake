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

      # Command-line apps
      just
      nix-output-monitor
      ripgrep
      starship
      wl-clipboard
      eza
    ];

    rum.programs.obs-studio.enable = true;

    ext.programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
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

      moar = {
        enable = true;
        settings = {
          no-statusbar = true;
          wrap = true;
        };
      };

      swaylock = {
        enable = true;
        package = pkgs.swaylock-effects;

        settings = {
          show-failed-attempts = true;
          ignore-empty-password = true;
          daemonize = true;

          screenshots = true;
          scaling = "fit";
          clock = true;
          indicator-idle-visible = true;
          grace = 3;
          effect-blur = "10x10";
          effect-vignette = "0.5:0.8";
          effect-pixelate = 4;

          text-color = "#cdd6f4";
          inside-color = "#181825";
          inside-clear-color = "#a6e3a1";
          inside-ver-color = "#cba6f7";
          inside-wrong-color = "#f38ba8";
          ring-color = "#1e1e2e";
          ring-clear-color = "#a6e3a1";
          ring-ver-color = "#cba6f7";
          ring-wrong-color = "#f38ba8";
          key-hl-color = "#eba0ac";
          bs-hl-color = "#6c7086";
          line-color = "#313244";

          timestr = "%H:%M";
          datestr = "%e %b '%y / %a";
        };
      };
    };
  };
}
