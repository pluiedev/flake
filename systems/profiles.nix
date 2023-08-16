{inputs}: rec {
  mkNixOS = name: {
    profile,
    system ? null,
    modules ? [],
    specialArgs ? {},
  }: let
    profile' = profile name inputs;
  in
    profile'.builder {
      system =
        if (system != null)
        then system
        else profile'.system;
      specialArgs = profile'.specialArgs // specialArgs;
      modules = profile'.modules ++ modules;
    };

  mkNixOSes = builtins.mapAttrs mkNixOS;

  personal = name: inputs @ {
    nixpkgs,
    nur,
    rust-overlay,
    home-manager,
    plasma-manager,
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
