{
  config,
  lib,
  ...
}: let
  cfg = config.pluie.desktop.sddm;
  inherit (lib) mkEnableOption mkOption mkIf types optional;
in {
  options.pluie.desktop.sddm = {
    enable = mkEnableOption "SDDM";

    theme = mkOption {
      type = types.nullOr types.package;
      default = null;
      description = "SDDM theme to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = optional (cfg.theme != null) cfg.theme;

    services.xserver.displayManager.sddm = {
      enable = true;
      theme = mkIf (cfg.theme != null) cfg.theme.themeName;
    };
  };
}
