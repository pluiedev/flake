{inputs, ...}:
with (import ./profiles.nix inputs); {
  flake.nixosConfigurations = mkSystems {
    tagliatelle.profile = personal;
    fettuccine.profile = personal;
  };
  flake.darwinConfigurations = mkSystems {
    fromage.profile = personal-mac;
  };
}
