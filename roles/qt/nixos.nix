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
    qt.enable = true;

    hm.xdg.configFile = mkIf (cfg.platform == "qt5ct") {
      "qt5ct/qt5ct.conf".text = mkIf (cfg.qt5ct.settings != null) (toINI cfg.qt5ct.settings);
      "qt6ct/qt6ct.conf".text = mkIf (cfg.qt6ct.settings != null) (toINI cfg.qt6ct.settings);
    };
  };
}
