{
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  options.roles.boot.lanzaboote.enable = lib.mkEnableOption "Lanzaboote, a secure boot implementation for NixOS";

  config = lib.mkIf config.roles.boot.lanzaboote.enable {
    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    boot.loader.systemd-boot.enable = lib.mkForce false;
  };
}
