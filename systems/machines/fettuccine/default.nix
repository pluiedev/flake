{
  nixos-hardware,
  lanzaboote,
  lib,
  ...
}: {
  imports = with nixos-hardware.nixosModules; [
    ./hardware-configuration.nix

    common-hidpi
    asus-zephyrus-gu603h

    lanzaboote.nixosModules.lanzaboote
  ];

  roles = {
    bluetooth.enable = true;
    nvidia.enable = true;
  };

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  boot.loader.systemd-boot.enable = lib.mkForce false;

  hardware.nvidia = {
    dynamicBoost.enable = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  specialisation.china.configuration = {
    roles.mirrors.chinese.enable = true;
    environment.variables.NIXOS_SPECIALISATION = "china";
  };
}
