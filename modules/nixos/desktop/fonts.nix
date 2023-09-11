{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.pluie.desktop.fonts;
  inherit (lib) mkIf;
in {
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
          serif = ["Noto Serif" "LXGW WenKai"];
          sansSerif = ["Rubik" "LXGW Neo XiHei"];
          emoji = ["Noto Color Emoji"];
          monospace = ["Iosevka Nerd Font" "LXGW Neo XiHei"];
        };
      };
    };
  };
}
