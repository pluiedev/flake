{ pkgs, lib, ... }:
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

  hm.catppuccin.hyprland.enable = true;

  hm.home.packages = with pkgs; [
    networkmanagerapplet # necessary for icons
  ];

  roles.qt =
    let
      common.settings.Appearance = {
        color_scheme_path = "${pkgs.catppuccin-qt5ct}/share/qt5ct/colors/Catppuccin-Mocha.conf";
        custom_palette = true;
      };
    in
    lib.genAttrs [
      "qt5ct"
      "qt6ct"
    ] (_: common);

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
