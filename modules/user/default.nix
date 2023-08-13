{lib, ...}: {
  imports = [
    ./ime.nix
    ./hm-shim.nix
    ./email.nix
  ];

  config.pluie.user.ime.enable = lib.mkDefault true;
}
