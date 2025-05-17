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
    files.".local/share/fcitx5/themes/catppuccin-${cfg.flavor}-${cfg.accent}".source =
      "${finalPackage}/share/fcitx5/themes/catppuccin-${cfg.flavor}-${cfg.accent}";

    files.".config/fcitx5/conf/classicui.conf".source = format.generate "fcitx5-classicui.conf" {
      globalSection = {
        Theme = "catppuccin-${cfg.flavor}-${cfg.accent}";
      };
    };
  };
}
