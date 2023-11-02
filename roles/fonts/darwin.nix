{
  config,
  lib,
  ...
}: let
  cfg = config.roles.fonts;
  inherit (lib) mkIf;
in {
  config = mkIf cfg.enable {
    fonts.fonts = cfg.packages;
  };
}
