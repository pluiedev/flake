{lib, ...}: {
  imports = [
    ./git.nix
    ./rust.nix
  ];

  config.pluie.user.tools.git.enable = lib.mkDefault true;
}
