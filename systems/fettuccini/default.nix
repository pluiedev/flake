{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  pluie = {
    hardware.nvidia.enable = true;
    locales.chinese.enable = true;
    desktop = {
      enable = true;
      plasma.enable = true;
    };
    patch.fix-246195 = true;
  };

  # Printing
  services.printing.enable = true;

  environment.systemPackages = with pkgs; [
    git
    gcc
  ];
}
