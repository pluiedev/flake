{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.roles.xdg;
in {
  options.roles.xdg = {
    enable = mkEnableOption "XDG" // {default = true;};
  };

  config = mkIf cfg.enable {
    hm.xdg.enable = true;
    hm.home.packages = [pkgs.xdg-utils];
  };
}
