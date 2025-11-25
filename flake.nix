{
  description = "Leah's NixOS configurations + more";

  nixConfig = {
    extra-substituters = [
      "https://pluiedev.cachix.org"
    ];
    extra-trusted-public-keys = [
      "pluiedev.cachix.org-1:tW7LdIlB2UV3DM/DOVlgxg0ON+8YJRIW1aKxPKFOwzI="
    ];
  };

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";

    # NOTE: please keep this in alphabetical order.

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:pluiedev/ghostty/edge";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem?rev=a1e391395fee2f2ddbb8e9efd5da68cf60406835";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem-rum = {
      url = "github:snugnug/hjem-rum";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:pluiedev/nixos-hardware/pluie/jj-nsvpsuspltqm";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;
      packages' =
        pkgs':
        pkgs'.lib.packagesFromDirectoryRecursive {
          inherit (pkgs') callPackage;
          directory = ./packages;
        };
      specialArgs = { inherit inputs; };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = lib.systems.flakeExposed;

      flake = {
        overlays.default = final: prev: packages' prev // import ./overlay.nix final prev;

        # Personal computers
        nixosConfigurations.fettuccine = lib.nixosSystem {
          modules = [ ./systems/fettuccine ];
          inherit specialArgs;
        };

        nixosConfigurations.pappardelle = lib.nixosSystem {
          modules = [ ./systems/pappardelle ];
          inherit specialArgs;
        };

        # Servers
        nixosConfigurations.focaccia = lib.nixosSystem {
          modules = [ ./systems/focaccia ];
          inherit specialArgs;
        };

        hjemModules = {
          hjem-ext = import ./modules/hjem-ext;
          hjem-ctp = import ./modules/hjem-ctp;
        };
      };

      perSystem =
        { pkgs, ... }:
        {
          packages = packages' pkgs;

          devShells.default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              nil
              nixfmt-rfc-style
            ];
          };
        };
    };
}
