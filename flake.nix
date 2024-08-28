{
  description = "Leah's NixOS configurations + more";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # NOTE: please keep this in alphabetical order.

    blender-bin = {
      url = "blender-bin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    ctp-discord-compiled = {
      url = "github:catppuccin/discord/gh-pages";
      flake = false;
    };

    ctp-vscode-compiled = {
      url = "github:catppuccin/vscode/catppuccin-vsc-v3.14.0";
      flake = false;
    };

    fenix = {
      url = "github:nix-community/fenix/monthly";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "sourcehut:~rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Only for input deduplication
    flake-utils.url = "github:numtide/flake-utils";

    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";
      inputs = {
        nixpkgs-stable.follows = "nixpkgs";
        nixpkgs-unstable.follows = "nixpkgs";
      };
    };

    krunner-nix = {
      url = "github:pluiedev/krunner-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };

    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = inputs:
    let
      packages' = pkgs': pkgs'.lib.packagesFromDirectoryRecursive {
        inherit (pkgs') callPackage;
        directory = ./packages;
      };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./hm-modules
        ./systems
      ];
      systems = [ "x86_64-linux" "x86_64-darwin" ];

      flake.overlays.default = _: packages';

      perSystem = { pkgs, ... }: {
        packages = packages' pkgs;
      };

      # perSystem =
      #   { pkgs, ... }:
      #   let
      #     treefmt = inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      #     formatter = treefmt.config.build.wrapper;
      #   in
      #   {
      #     inherit formatter;
      #     devShells.default = pkgs.mkShell { packages = [ formatter ]; };
      #     checks.formatting = treefmt.config.build.check inputs.self;
      #   };
    };
}
