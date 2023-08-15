{
  config,
  lib,
  pkgs,
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

    services.xserver = {
      displayManager.sddm = {
        enable = true;
        theme = mkIf (cfg.sddmTheme != null) cfg.sddmTheme.themeName;
      };
      desktopManager.plasma5 = {
        enable = true;
        useQtScaling = true;
      };
    };
  };
}
