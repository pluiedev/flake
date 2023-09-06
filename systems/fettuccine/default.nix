{nixos-hardware, ...}: {
  imports = with nixos-hardware.nixosModules; [
    ./hardware-configuration.nix

    common-pc-laptop
    common-pc-laptop-ssd
    common-hidpi
    common-cpu-intel
    common-gpu-nvidia
  ];

  pluie = {
    hardware.nvidia.enable = true;
    desktop = {
      enable = true;
      plasma.enable = true;
    };
    patch.fix-246195 = true;
  };

  hardware.bluetooth.enable = true;

  hardware.nvidia = {
    powerManagement.enable = true;

    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
