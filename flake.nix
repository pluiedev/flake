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

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tangled = {
      url = "git+https://tangled.org/tangled.org/core?shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";

        # We don't need any of these
        flake-compat.follows = "";
        indigo.follows = "";
        htmx-src.follows = "";
        htmx-ws-src.follows = "";
        lucide-src.follows = "";
        inter-fonts-src.follows = "";
        actor-typeahead-src.follows = "";
        ibm-plex-mono-src.follows = "";
      };
    };

    tranquil-pds = {
      url = "git+https://tangled.org/lewis.moe/bspds-sandbox?rev=32fee7a7fff8493b78ca078a840b5819718f297d";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
      ];

      imports = [
        ./overlay.nix
        ./systems/fettuccine
        ./systems/pappardelle
        ./systems/focaccia
      ];

      flake = {
        hjemModules = {
          hjem-ext = import ./modules/hjem-ext;
          hjem-ctp = import ./modules/hjem-ctp;
        };

        checks =
          let
            deployChecks = builtins.mapAttrs (
              _: deployLib: deployLib.deployChecks inputs.self.deploy
            ) inputs.deploy-rs.lib;
          in
          deployChecks // inputs.self.packages;
      };

      perSystem =
        {
          pkgs,
          lib,
          system,
          ...
        }:
        {
          # Allow Flake checks to pass
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          packages = lib.packagesFromDirectoryRecursive {
            inherit (pkgs) callPackage;
            directory = ./packages;
          };

          devShells.default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              nixd
              nixfmt
              deploy-rs
            ];
          };
        };
    };
}
