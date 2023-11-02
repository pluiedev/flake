{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.roles.fish;
in {
  config = mkIf cfg.enable {
    programs.fish.enable = true;
    hm.programs.fish.enable = true;

    roles.base.user.shell = mkIf cfg.defaultShell pkgs.fish;
  };
}
