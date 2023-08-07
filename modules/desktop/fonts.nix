{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.pluie.desktop.fonts;
  inherit (lib) mkEnableOption mkIf;
in {
  options.pluie.desktop.fonts.enable = mkEnableOption "default fonts";

  config = mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = true;

      packages = with pkgs; [
        (nerdfonts.override {fonts = ["Iosevka"];})
        # Apparently to NixOS, having Old North Arabian support out-of-the-box
        # is more important than having Chinese or Japanese fonts. Wow.
        noto-fonts
        noto-fonts-extra
        noto-fonts-emoji
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        lxgw-wenkai
        lxgw-neoxihei
        rubik
      ];

      fontconfig = {
        enable = true;
        defaultFonts = {
          serif = ["Noto Serif"];
          sansSerif = ["Rubik"];
          emoji = ["Noto Color Emoji"];
          monospace = ["Iosevka Nerd Font"];
        };
      };
    };
  };
}
