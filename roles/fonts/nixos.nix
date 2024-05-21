{ config, lib, ... }:
let
  cfg = config.roles.fonts;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    fonts = {
      inherit (cfg) packages;
      enableDefaultPackages = true;

      fontconfig = {
        enable = true;
        defaultFonts = cfg.defaults;
      };
    };
  };
}
