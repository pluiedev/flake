{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf getExe';
  cfg = config.roles.bluetooth;
in {
  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    hm.services.blueman-applet.enable = true;

    roles.hyprland.settings.exec-once = [
      (getExe' pkgs.blueman "blueman-applet")
    ];
  };
}
