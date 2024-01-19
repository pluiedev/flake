{
  description = "Leah's NixOS configurations + more";

  nixConfig = {
    extra-substituters = ["https://cache.garnix.io"];
    extra-trusted-public-keys = ["cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="];
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # NOTE: please keep this in alphabetical order.

    blender-bin = {
      url = "blender-bin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Only ever used for tracking and locking revs
    ctp-discord-compiled = {
      url = "github:catppuccin/discord/gh-pages";
      flake = false;
    };

    ctp-nix.url = "github:Stonks3141/ctp-nix";

    # Only ever used for tracking and locking revs
    ctp-vscode-compiled = {
      url = "github:catppuccin/vscode/compiled";
      flake = false;
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Only here for input deduplication
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nur.url = "github:nix-community/NUR";

    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake
    {inherit inputs;}
    {
      imports = [
        ./packages
        ./systems
        ./templates
      ];
      systems = [
        "x86_64-linux"
      ];
    };
}
