{lib, ...}: {
  imports = [
    ./desktop
    ./nix.nix
    ./upgrade-diff.nix
  ];

  options.pluie.enableChineseMirrors = lib.mkEnableOption "Chinese mirror sites to speed up downloads in Mainland China";
}
