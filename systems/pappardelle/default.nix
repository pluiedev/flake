{
  inputs,
  lib,
  ...
}:
{
  flake.nixosConfigurations.pappardelle = lib.nixosSystem {
    modules = [ ./configuration.nix ];
    specialArgs = { inherit inputs; };
  };
}
