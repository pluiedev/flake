{ inputs, self, lib, ... }: {
  flake = let
    inherit (inputs) nur home-manager nixpkgs;
  in {
    nixosConfigurations.tagliatelle = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ../../utils/upgrade-diff.nix
        #../../utils/check.nix
        nur.nixosModules.nur
        home-manager.nixosModules.home-manager
        { nixpkgs.overlays = [nur.overlay]; }
        ../../users/leah 
      ];
      specialArgs = inputs;
    };
  };
}
