{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.pluie.desktop.ime;
  inherit (lib) mkEnableOption mkIf;
in {
  options.pluie.desktop.ime.enable = mkEnableOption "IMEs with Fcitx5";

  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-rime
      ];
    };
  };
}
