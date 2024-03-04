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

  specialisation.china.configuration = {
    roles.mirrors.chinese.enable = true;
    environment.variables.NIXOS_SPECIALISATION = "china";
  };
}
