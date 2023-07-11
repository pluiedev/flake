{
  description = "Leah's NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake
    {inherit inputs;}
    {
      systems = ["x86_64-linux"];
      imports = [
        ./systems
        ./utils
      ];
    };
}
