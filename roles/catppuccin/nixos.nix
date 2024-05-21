{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.roles.catppuccin) enable flavour accent;

  mkUpper =
    str: with builtins; (lib.toUpper (substring 0 1 str)) + (substring 1 (stringLength str) str);
  Flavour = mkUpper flavour;
in
{
  config = lib.mkIf enable {
    hm.gtk = {
      enable = true;
      catppuccin = {
        enable = true;
        tweaks = [ "rimless" ];
        size = "compact";
        cursor.enable = true;
      };

      cursorTheme.size = 32;
    };

    hm.wayland.windowManager.hyprland.catppuccin.enable = true;

    console.catppuccin.enable = true;

    roles.qt =
      let
        common.settings.Appearance = {
          color_scheme_path = "${pkgs.catppuccin-qt5ct}/share/qt5ct/colors/Catppuccin-${Flavour}.conf";
          custom_palette = true;
        };
      in
      lib.genAttrs [
        "qt5ct"
        "qt6ct"
      ] (_: common);

    # TODO: figure out how to apply this via plasmarc
    hm.home.packages =
      let
        plasmaEnabled = config.services.desktopManager.plasma6.enable;
      in
      lib.optional plasmaEnabled (
        pkgs.catppuccin-kde.override {
          flavour = [ flavour ];
          accents = [ accent ];
        }
      )
      ++ [ (pkgs.catppuccin-konsole.override { flavors = [ flavour ]; }) ];
  };
}
