{ config, lib, ... }:
let
  inherit (lib.lists) optional;

  cfg = config.roles.base;
in
{
  config = {
    roles.base.user = {
      isNormalUser = true;
      description = cfg.realName;
      extraGroups = optional cfg.canSudo "wheel";
      home = "/home/${cfg.username}";
    };

    hm.home.stateVersion = config.system.stateVersion;
  };
}
