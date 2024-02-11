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
    # services.blueman.enable = true;
  };
}
