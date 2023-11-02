{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.roles.qt;
in {
  config = lib.mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme = "qt5ct";
    };

    hm.xdg.configFile = let
      src = ./qtct.conf;
      theme =
        if (cfg.theme != null)
        then cfg.theme
        else "";
    in {
      "qt5ct/qt5ct.conf".source = pkgs.substituteAll {
        inherit src theme;
        style = "Breeze";
      };
      "qt6ct/qt6ct.conf".source = pkgs.substituteAll {
        inherit src theme;
        style = "Fusion"; # Change this to Breeze when Plasma 6 is packaged ofc
      };
    };
  };
}
