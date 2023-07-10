{
  description = "Leah's NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";
  };
  outputs = inputs @ {
    nixpkgs,
    nur,
    home-manager,
    ...
  }: {
    nixosConfigurations.tagliatelle = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ./upgrade-diff.nix
        nur.nixosModules.nur
        home-manager.nixosModules.home-manager
        {
          nixpkgs.overlays = [nur.overlay];
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.leah.imports = [./home.nix];
          };
        }
      ];
      specialArgs = inputs;
    };
  };
}
