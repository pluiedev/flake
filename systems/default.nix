{ withSystem, inputs, self, ... }:
let
  mkMachine =
    name: { system, modules, builder }:
    withSystem system ({ inputs', self', ... }:
      builder {
        specialArgs = { inherit inputs inputs' self self'; };
        modules = modules ++ [
          ./${name}
          {
            networking.hostName = name;
            nixpkgs.hostPlatform = system;
          }
        ];
      }
    );

  mkMachines = builtins.mapAttrs mkMachine;

  # Composable parts
  personal = [
    inputs.home-manager.nixosModules.home-manager
    ../users/personal.nix
  ];
  nixos = [ ../roles/nixos.nix ];
  darwin = [ ../roles/darwin.nix ];

  # Presets
  nixos-pc = {
    system = "x86_64-linux";
    modules = nixos ++ personal;
    builder = inputs.nixpkgs.lib.nixosSystem;
  };
  darwin-pc = {
    system = "x86_64-darwin";
    modules = darwin ++ personal;
    builder = inputs.nix-darwin.lib.darwinSystem;
  };
in
{
  flake = {
    nixosConfigurations = mkMachines {
      fettuccine = nixos-pc;
      tagliatelle = nixos-pc;
    };
    darwinConfigurations = mkMachines {
      fromage = darwin-pc;
    };
  };
}
