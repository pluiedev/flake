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
        noto-fonts
        noto-fonts-extra
        noto-fonts-emoji
        lxgw-wenkai
        lxgw-neoxihei
        rubik
      ];

      fontconfig = {
        enable = true;
        defaultFonts = {
          serif = ["LXGW WenKai" "Noto Serif"];
          sansSerif = ["LXGW Neo XiHei" "Rubik"];
          emoji = ["Noto Color Emoji"];
          monospace = ["LXGW Neo XiHei" "Iosevka Nerd Font"];
        };
      };
    };
  };
}
