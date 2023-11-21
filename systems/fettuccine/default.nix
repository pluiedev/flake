{nixos-hardware, ...}: {
  imports = with nixos-hardware.nixosModules; [
    ./hardware-configuration.nix

    common-hidpi
    asus-zephyrus-gu603h
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
    };
  };

  hm.programs.wpaperd.settings.default.path = "${./wallpaper.png}";

  time.timeZone = "Europe/Berlin";
}
