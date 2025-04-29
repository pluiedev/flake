{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations = {
    fettuccine = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./fettuccine
        ../users/leah
      ];
      specialArgs = {
        inherit inputs self;
      };
    };
  };
}
