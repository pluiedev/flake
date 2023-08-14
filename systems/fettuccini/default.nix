_: {
  imports = [./hardware-configuration.nix];

  pluie = {
    hardware.nvidia.enable = true;
    locales.chinese.enable = true;
    desktop = {
      enable = true;
      plasma.enable = true;
    };
    patch.fix-246195 = true;
  };

  hardware.bluetooth.enable = true;

  # Printing
  services.printing.enable = true;
}
