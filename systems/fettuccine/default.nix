{nixos-hardware, ...}: {
  imports = with nixos-hardware.nixosModules; [
    ./hardware-configuration.nix

    common-pc-laptop
    common-pc-laptop-ssd
    common-hidpi
    common-cpu-intel
    common-gpu-nvidia
  ];

  roles = {
    bluetooth.enable = true;
    nvidia.enable = true;
  };

  # Don't need this with a high enough DPI
  fonts.fontconfig.hinting.enable = false;

  hardware.nvidia = {
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
}
