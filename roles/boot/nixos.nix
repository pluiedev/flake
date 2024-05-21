{ config, lib, ... }:
let
  cfg = config.roles.boot;
in
{
  imports = [ ./fix-246195 ];

  config = lib.mkIf cfg.enable {
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
