{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.pluie.desktop.plasma;
  inherit (lib) mkEnableOption mkIf;
in {
  options.pluie.desktop.plasma = {
    enable = mkEnableOption "Plasma";
  };

  config = mkIf cfg.enable {
    services.xserver.desktopManager.plasma5 = {
      enable = true;
      useQtScaling = true;
    };

    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-kde];
  };
}
