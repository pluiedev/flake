{nixos-hardware, ...}: {
  imports = with nixos-hardware.nixosModules; [
    ./hardware-configuration.nix

    common-pc-laptop
    common-pc-laptop-ssd
    common-hidpi
    common-cpu-intel
    common-gpu-nvidia
  ];

  boot.extraModprobeConfig = ''
    options nvidia NVreg_PreserveVideoMemoryAllocations=1 NVreg_TemporaryFilePath=/var/tmp
  '';

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
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    dynamicBoost.enable = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  time.timeZone = "Europe/Berlin";

  virtualisation.docker.enable = true;
}
