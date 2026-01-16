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

        # deploy-rs Nodes
        deploy.nodes.focaccia = {
          sshOpts = [
            "-p"
            "42069"
          ];
          hostname = "focaccia.pluie.me";
          profiles = {
            system = {
              path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations.focaccia;
              user = "root";
              sshUser = "root";
            };
          };
        };

        # This is highly advised, and will prevent many possible mistakes
        checks = builtins.mapAttrs (
          _: deployLib: deployLib.deployChecks inputs.self.deploy
        ) inputs.deploy-rs.lib;
      };

      perSystem =
        {
          pkgs,
          system,
          ...
        }:
        {
          # Allow Flake checks to pass
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          packages = packages' pkgs;

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
