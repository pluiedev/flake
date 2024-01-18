{
  config,
  lib,
  pkgs,
  nix-gaming,
  ...
}: {
  imports = [
    ./1password
    ./containers
    ./discord
    ./fcitx5
    ./firefox
    ./hyprland
    ./nvim
    #./plasma
    ./qt
    ./rust

    ./programs.nix
  ];

  # Makes testing aarch64 packaging a lot easier
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  roles.base = {
    username = "leah";
    realName = "Leah";
    fullName = "Leah Amelia Chen";
    canSudo = true;
  };

  roles.catppuccin = {
    enable = true;
    flavour = "mocha";
    accent = "maroon";
  };
  roles.dolphin.enable = true;

  roles.email = let
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

  roles.fonts = {
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

  roles.fish = {
    enable = true;
    defaultShell = true;
  };
  roles.git = {
    enable = true;
    signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC7uJGE2/25M4a3DIVxtnTA5INqWsFGw+49qHXaN/kqy";
  };

  programs = {
    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraProfile = ''
          export STEAM_EXTRA_COMPAT_TOOLS_PATHS="${nix-gaming.packages.${pkgs.system}.proton-ge}"
        '';
      };
      remotePlay.openFirewall = true;
    };
    nix-ld.enable = true;
  };

  services.gnome.gnome-keyring.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${lib.getExe pkgs.greetd.tuigreet} --time --user-menu -r --remember-user-session -g 'Welcome back! <3' --asterisks --cmd ${lib.getExe pkgs.hyprland}";
      user = "greeter";
    };
  };

  services.upower.enable = true;

  # Stop the damn TUI from bleeding
  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  # https://github.com/apognu/tuigreet/issues/68#issuecomment-1586359960
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [80 443 5173];
  };
}
