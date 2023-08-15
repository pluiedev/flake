{lib, ...}: {
  imports = [
    ./fish
    ./git.nix
    ./rust.nix
  ];

  config.pluie.tools.git.enable = lib.mkDefault true;
}
