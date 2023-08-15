{nixos-hardware, ...}: {
  imports = [
    ./hardware-configuration.nix

    nixos-hardware.nixosModules.common-pc-laptop
    nixos-hardware.nixosModules.common-pc-laptop-ssd
    nixos-hardware.nixosModules.common-hidpi
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-gpu-nvidia
  ];

  pluie = {
    hardware.nvidia.enable = true;
    locales.chinese.enable = true;
    desktop = {
      enable = true;
      plasma.enable = true;
    };
    patch.fix-246195 = true;
  };

  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;

  hardware.nvidia = {
    powerManagement.enable = true;

    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Printing
  services.printing.enable = true;
}
