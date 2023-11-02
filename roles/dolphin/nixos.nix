{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf getExe';
  cfg = config.roles.dolphin;
in {
  config = mkIf cfg.enable {
    hm.home.packages = [pkgs.dolphin];

    # TODO: annoy maintainers to add meta.mainProgram
    roles.hyprland.settings.bind = ["$mod, E, exec, ${getExe' pkgs.dolphin "dolphin"}"];

    # Required for detecting storage devices
    services.udisks2.enable = true;
  };
}
