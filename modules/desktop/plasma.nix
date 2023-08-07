{
  config,
  lib,
  ...
}: let
  cfg = config.pluie.desktop.plasma;
  inherit (lib) mkEnableOption mkIf;
in {
  options.pluie.desktop.plasma.enable = mkEnableOption "Plasma";

  config = mkIf cfg.enable {
    services.xserver = {
      displayManager.sddm = {
        enable = true;
        theme = "flutter";
      };
      desktopManager.plasma5 = {
        enable = true;
        useQtScaling = true;
      };
    };
  };
}
