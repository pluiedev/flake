_: {
  imports = [
    ../common
    ../user/common

    ./desktop
    ./hardware
    ./patch
  ];

  config.pluie.user.modules = [../user/nixos];
}
