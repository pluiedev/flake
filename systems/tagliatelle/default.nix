{nixos-hardware, ...}: {
  imports = [
    ./hardware-configuration.nix

    nixos-hardware.nixosModules.common-pc
    nixos-hardware.nixosModules.common-pc-ssd
    nixos-hardware.nixosModules.common-hidpi
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
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

  # My old crusty Seagate hard drive
  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/a7ce57bd-de6f-420f-96b2-60a9581ccf9a";
    fsType = "ext4";
  };

  # Fedora
  fileSystems."/mnt/fedora" = {
    device = "/dev/disk/by-uuid/7350ad79-2a8c-4475-99f1-7721699b5a41";
    fsType = "btrfs";
  };
}
