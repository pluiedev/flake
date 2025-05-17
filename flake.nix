{
  description = "Leah's NixOS configurations + more";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";

    # NOTE: please keep this in alphabetical order.

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:pluiedev/ghostty/edge";
      inputs = {
        nixpkgs-unstable.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
      };
    };

    hjem = {
      url = "github:feel-co/hjem";
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

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
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
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = lib.systems.flakeExposed;

      flake = {
        overlays.default = _: packages';

        nixosConfigurations.fettuccine = lib.nixosSystem {
          modules = [ ./systems/fettuccine ];
          specialArgs = { inherit inputs; };
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

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              nil
              nixfmt-rfc-style
            ];
          };
        };
    };
}
