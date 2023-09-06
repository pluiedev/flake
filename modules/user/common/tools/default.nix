{lib, ...}: {
  imports = [
    ./fish
    ./git.nix
    ./rust.nix
  ];

  config.pluie.user.tools.git.enable = lib.mkDefault true;
}
