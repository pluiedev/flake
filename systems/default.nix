{inputs, ...}: let
  profiles = import ./profiles.nix;

  mkNixOS = name: spec: let
    inputs' = inputs // {inherit name;};
    profile = spec.profile inputs';
    modules = spec.modules or [];
    system = spec.system or profile.system;
    specialArgs = spec.specialArgs or profile.specialArgs;
  in
    profile.builder {
      inherit specialArgs system;
      modules = profile.modules ++ modules;
    };

  mkNixOSes = builtins.mapAttrs mkNixOS;
in {
  flake.nixosConfigurations = mkNixOSes {
    tagliatelle = {
      profile = profiles.personal;
    };
  };
}
