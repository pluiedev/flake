{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.pluie.desktop.plasma;
  inherit (lib) mkEnableOption mkIf;
in {
  options.pluie.desktop.plasma.enable = mkEnableOption "Plasma";

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.sddm-theme-flutter];
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
