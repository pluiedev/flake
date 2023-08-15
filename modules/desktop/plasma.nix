{
  config,
  lib,
  pkgs,
  plasma-manager,
  ...
}: let
  cfg = config.pluie.desktop.plasma;
  inherit (lib) mkEnableOption mkOption mkIf types optional;
in {
  options.pluie.desktop.plasma = {
    enable = mkEnableOption "Plasma";

    sddmTheme = mkOption {
      type = types.nullOr types.package;
      default = pkgs.sddm-theme-flutter;
      description = "SDDM theme to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = optional (cfg.sddmTheme != null) cfg.sddmTheme;

    services.xserver.displayManager.sddm = {
      enable = true;
      theme = mkIf (cfg.sddmTheme != null) cfg.sddmTheme.themeName;
    };

    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-kde];

    pluie.user = {
      modules = [plasma-manager.homeManagerModules.plasma-manager];
      config.programs.plasma = {
        enable = true;
      };
    };
  };
}
