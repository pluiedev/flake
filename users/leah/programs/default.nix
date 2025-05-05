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
    gamemode.enable = true;
    localsend.enable = true;
    nix-index-database.comma.enable = true;
  };

  services.spice-webdavd.enable = true;
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  hjem.users.leah = {
    packages = with pkgs; [
      # Apps
      nekoray
      prismlauncher
      vlc
      thunderbird
      telegram-desktop
      gnome-boxes

      # Command-line apps
      just
      nix-output-monitor
      ripgrep
      starship
      wl-clipboard
      eza
    ];

    files.".config/starship.toml".source = ./starship.toml;

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
    };
  };
}
