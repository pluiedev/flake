{
  perSystem = {pkgs, ...}: {
    packages = import ./packages.nix {inherit pkgs;};
  };
}
