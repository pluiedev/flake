{
  description = "Leah's NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nixosConfigurations.tagliatelle = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
      	./configuration.nix
	      home-manager.nixosModules.home-manager
	      {
	        home-manager = {
            useGlobalPkgs = true;
	          useUserPackages = true;
	          users.leah = import ./home.nix;
          };
	      }
      ];
      specialArgs = inputs;
    };
  };
}

