{nixos-hardware, ...}: {
  imports = with nixos-hardware.nixosModules; [
    ./hardware-configuration.nix

    common-pc
    common-pc-ssd
    common-hidpi
    common-cpu-amd
    common-gpu-nvidia-nonprime
  ];

  roles = {
    nvidia.enable = true;
    patch.fix-246195 = true;
    mirrors.chinese.enable = true;
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
