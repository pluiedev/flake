{inputs, ...}: let
  inherit (import ./profiles.nix {inherit inputs;}) mkNixOSes personal;
in {
  flake.nixosConfigurations = mkNixOSes {
    tagliatelle = {profile = personal;};
    fettuccini = {profile = personal;};
  };
}
