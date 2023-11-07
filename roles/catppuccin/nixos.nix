{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.roles.catppuccin) enable flavour;

  mkUpper = str:
    with builtins;
      (lib.toUpper (substring 0 1 str)) + (substring 1 (stringLength str) str);
  Flavour = mkUpper flavour;
in {
  config = lib.mkIf enable {
    hm.gtk = {
      enable = true;
      catppuccin = {
        enable = true;
        tweaks = ["rimless"];
        size = "compact";
        cursor.enable = true;
      };

      cursorTheme.size = 24;
    };

    hm.wayland.windowManager.hyprland.catppuccin.enable = true;

    roles.qt.theme = "${pkgs.catppuccin-qtct}/share/qt5ct/colors/Catppuccin-${Flavour}.conf";

    # see catppuccin/tty
    # absolutely deranged
    boot.kernelParams = [
      "vt.default_red=30,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166"
      "vt.default_grn=30,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173"
      "vt.default_blu=46,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200"
    ];
  };
}
