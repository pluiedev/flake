{inputs, ...}:
with (import ./profiles.nix {inherit inputs;}); {
  flake.nixosConfigurations = builtins.mapAttrs mkNixOS {
    tagliatelle.profile = personal;
    fettuccine.profile = personal;
  };
  flake.darwinConfigurations = builtins.mapAttrs mkDarwin {
    fromage.profile = personal-mac;
  };
}
