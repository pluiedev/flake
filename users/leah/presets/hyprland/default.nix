{ pkgs, ... }:
{
  imports = [
    ./waybar

    ./clipboard.nix
    ./dolphin.nix
    ./greetd.nix
    ./mako.nix
    ./media.nix
    ./qt.nix
    ./screenshots.nix
    ./settings.nix
  ];

  roles.hyprland.enable = true;

  hm.home.packages = with pkgs; [
    networkmanagerapplet # necessary for icons
  ];

  hm.programs = {
    kitty.enable = true;

    wpaperd = {
      enable = true;
      settings.default.path = "${./wallpaper.png}";
    };

    fuzzel = {
      enable = true;
      settings.main = {
        font = "Iosevka Nerd Font:size=13";
        dpi-aware = true;
      };
    };
  };

  hm.services = {
    blueman-applet.enable = true;

    mako = {
      enable = true;
      anchor = "top-right";
    };
  };

  services.gnome.gnome-keyring.enable = true;
  services.upower.enable = true;
}
