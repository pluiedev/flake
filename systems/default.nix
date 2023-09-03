{inputs, ...}:
with (import ./profiles.nix {inherit inputs;}); {
  flake.nixosConfigurations = mkSystems {
    tagliatelle.profile = personal;
    fettuccine.profile = personal;
  };
  flake.darwinConfigurations = mkSystems {
    fromage.profile = personal-mac;
  };
}
