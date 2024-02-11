{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./containers
    ./presets/plasma
    ./programs
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

  roles.email = let
    realName = config.roles.base.fullName;
    host = {
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
        inherit realName host;
        primary = true;
      };
      "acc@pluie.me" = {
        inherit host;
        realName = "${realName} [accounts]";
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
      libertinus
      lxgw-wenkai
      lxgw-neoxihei
      rubik
    ];

    defaults = {
      serif = ["Libertinus Serif" "LXGW WenKai"];
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

  environment.variables.NIXOS_OZONE_WL = "1";

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [80 443 5173];
  };
}
