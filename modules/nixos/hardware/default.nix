_: {
  imports = [
    ./nvidia.nix
  ];

  config.boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
