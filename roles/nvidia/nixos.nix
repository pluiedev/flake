{ config, lib, ... }:
let
  cfg = config.roles.plasma;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    hardware.nvidia = {
      open = true;

      powerManagement = {
        enable = true;
        # finegrained = true;
      };
    };
    services.xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
    };
  };
}
