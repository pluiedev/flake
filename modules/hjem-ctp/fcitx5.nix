{
  config,
  lib,
  ctp-lib,
  pkgs,
  ...
}:
let
  cfg = config.ctp.fcitx5;
  format = pkgs.formats.iniWithGlobalSection { };

  finalPackage = pkgs.catppuccin-fcitx5.override {
    inherit (cfg) withRoundedCorners;
  };
in
{
  options.ctp.fcitx5 = ctp-lib.mkCatppuccinOptions "Fcitx5" { withAccent = true; } // {
    withRoundedCorners = lib.mkEnableOption "rounded corners";
  };

  config = lib.mkIf cfg.enable {
    xdg.data.files."fcitx5/themes/catppuccin-${cfg.flavor}-${cfg.accent}".source =
      "${finalPackage}/share/fcitx5/themes/catppuccin-${cfg.flavor}-${cfg.accent}";

    xdg.config.files."fcitx5/conf/classicui.conf".source = format.generate "fcitx5-classicui.conf" {
      globalSection = {
        Theme = "catppuccin-${cfg.flavor}-${cfg.accent}";
      };
    };
  };
}
