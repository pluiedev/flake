{ config, lib, ... }:
let
  cfg = config.roles.boot;
in
{
  config = lib.mkIf cfg.enable {
    boot.loader = {
      systemd-boot = {
        enable = true;
        editor = false;
        consoleMode = "2";
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
  };
}
