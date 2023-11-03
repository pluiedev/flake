{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./1password
    ./discord
    ./fcitx5
    ./firefox
    ./hyprland
    ./nvim
    #./plasma
    ./rust

    ./programs.nix
  ];

  # Makes testing aarch64 packaging a lot easier
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  roles = {
    base = {
      username = "leah";
      realName = "Leah";
      fullName = "Leah Amelia Chen";
      canSudo = true;
    };

    catppuccin = {
      enable = true;
      variant = "mocha";
      accent = "maroon";
    };
    dolphin.enable = true;

    email = let
      migadu = {
        imap = {
          host = "imap.migadu.com";
          port = 993;
        };
        smtp = {
          host = "smtp.migadu.com";
          port = 465;
        };
      };
    in {
      enable = true;
      accounts = {
        "hi@pluie.me" = {
          primary = true;
          realName = config.roles.base.fullName;
          host = migadu;
        };
        "acc@pluie.me" = {
          realName = "${config.roles.base.fullName} [accounts]";
          host = migadu;
        };
      };
    };

    fonts = {
      enable = true;
      packages = with pkgs; [
        (nerdfonts.override {fonts = ["Iosevka"];})
        noto-fonts
        noto-fonts-extra
        noto-fonts-emoji
        lxgw-wenkai
        lxgw-neoxihei
        rubik
      ];

      defaults = {
        serif = ["Noto Serif" "LXGW WenKai"];
        sansSerif = ["Rubik" "LXGW Neo XiHei"];
        emoji = ["Noto Color Emoji"];
        monospace = ["Iosevka Nerd Font" "LXGW Neo XiHei"];
      };
    };

    fish = {
      enable = true;
      defaultShell = true;
    };
    git = {
      enable = true;
      signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC7uJGE2/25M4a3DIVxtnTA5INqWsFGw+49qHXaN/kqy";
    };
  };

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
    nix-ld.enable = true;
  };
  hm.programs = {
    starship = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };

    nix-index.enable = true;
  };
}
