{inputs}: rec {
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

  personal = inputs @ {
    name,
    nixpkgs,
    nur,
    rust-overlay,
    home-manager,
    ragenix,
    ...
  }: {
    system = "x86_64-linux";
    builder = nixpkgs.lib.nixosSystem;

    modules = [
      home-manager.nixosModules.home-manager
      nur.nixosModules.nur
      ragenix.nixosModules.default

      ./${name}
      ../users/leah
      ../modules

      {
        networking.hostName = name;
        system.stateVersion = "23.11";

        nixpkgs.overlays = [
          nur.overlay
          rust-overlay.overlays.default
          (import ../nixpkgs/overlay.nix)
        ];
      }
    ];
    specialArgs = inputs;
  };
}
