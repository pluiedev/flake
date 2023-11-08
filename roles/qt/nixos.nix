{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  toINI = lib.generators.toINI {};
  cfg = config.roles.qt;
in {
  config = mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme = "qt5ct";
    };

    hm.xdg.configFile = {
      "qt5ct/qt5ct.conf".text = mkIf (cfg.qt5.settings != null) (toINI cfg.qt5.settings);
      "qt6ct/qt6ct.conf".text = mkIf (cfg.qt6.settings != null) (toINI cfg.qt6.settings);
    };
  };
}
