{inputs, ...}:
with (import ./profiles.nix inputs); {
  flake.nixosConfigurations = mkSystems {
    tagliatelle = {
      profile = personal;
      modules = [../users/leah];
    };
    fettuccine = {
      profile = personal;
      modules = [../users/leah];
    };
  };
  flake.darwinConfigurations = mkSystems {
    fromage = {
      profile = personal-mac;
      modules = [../users/leah];
    };
  };
}
