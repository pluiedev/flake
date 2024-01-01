{
  lib,
  nixpkgs,
  ...
} @ inputs: let
  inherit (lib) mkDefault;
in {
  nix = {
    registry = {
      nixpkgs.flake = nixpkgs;
      n.flake = nixpkgs;
    };
    nixPath = let
      toNixPath = input: "${input}=${inputs.${input}.outPath}";
    in [
      (toNixPath "nixpkgs")
    ];

    gc = {
      automatic = mkDefault true;
      dates = mkDefault "weekly";
      options = mkDefault "--delete-older-than 7d";
    };

    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes" "auto-allocate-uids" "repl-flake"];
      trusted-users = ["@wheel"];
    };
  };
  nixpkgs = {
    # I'm not part of the FSF and I don't care
    config.allowUnfree = true;

    overlays = [
      (import ../../packages/overlay.nix)
    ];
  };
}
