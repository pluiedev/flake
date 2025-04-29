{
  description = "Leah's NixOS configurations + more";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # NOTE: please keep this in alphabetical order.

    # ctp-discord-compiled = {
    #   url = "github:catppuccin/discord/gh-pages";
    #   flake = false;
    # };

    # ctp-vscode-compiled = {
    #   url = "github:catppuccin/vscode/catppuccin-vsc-v3.14.0";
    #   flake = false;
    # };

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

    # lanzaboote = {
    #   url = "github:nix-community/lanzaboote";
    #   inputs = {
    #     flake-parts.follows = "flake-parts";
    #     nixpkgs.follows = "nixpkgs";
    #   };
    # };

    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # plasma-manager = {
    #   url = "github:nix-community/plasma-manager";
    #   inputs = {
    #     home-manager.follows = "home-manager";
    #     nixpkgs.follows = "nixpkgs";
    #   };
    # };
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
      imports = [ ./systems ];

      systems = lib.systems.flakeExposed;

      flake = {
        overlays.default = _: packages';
        hjemModules = {
          hjem-ext.imports = lib.fileset.toList (
            lib.fileset.fileFilter (file: file.hasExt "nix") ./modules/hjem-ext
          );
          hjem-ctp.imports = lib.fileset.toList (
            lib.fileset.fileFilter (file: file.hasExt "nix") ./modules/hjem-ctp
          );
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
