{
  inputs,
  lib,
  ...
}:
{
  flake.nixosConfigurations.fettuccine = lib.nixosSystem {
    modules = [ ./configuration.nix ];
    specialArgs = { inherit inputs; };
  };
}
