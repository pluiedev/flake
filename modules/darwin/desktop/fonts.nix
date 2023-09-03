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
    fonts.fonts = with pkgs; [
      (nerdfonts.override {fonts = ["Iosevka"];})
      noto-fonts
      noto-fonts-extra
      noto-fonts-emoji
      lxgw-wenkai
      lxgw-neoxihei
      rubik
    ];
  };
}
