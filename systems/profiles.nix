{inputs}: rec {
  mkSystem = name: {
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
  mkSystems = builtins.mapAttrs mkSystem;

  personal = name: inputs @ {
    nixpkgs,
    nur,
    rust-overlay,
    home-manager,
    plasma-manager,
    ragenix,
    ...
  }: rec {
    system = "x86_64-linux";
    builder = nixpkgs.lib.nixosSystem;

    modules = [
      home-manager.nixosModules.home-manager
      nur.nixosModules.nur
      ragenix.nixosModules.default

      ./${name}
      ../users/leah
      ../modules/nixos

      {
        networking.hostName = name;
        system.stateVersion = "23.11";
        nixpkgs.hostPlatform = system;
      }
    ];
    specialArgs = inputs;
  };

  personal-mac = name: inputs @ {
    nix-darwin,
    home-manager,
    ...
  }: rec {
    system = "x86_64-darwin";
    builder = nix-darwin.lib.darwinSystem;
    modules = [
      home-manager.darwinModules.home-manager

      ./${name}
      ../users/leah
      ../modules/darwin

      {
        networking.hostName = name;
        system.stateVersion = 4;
        nixpkgs.hostPlatform = system;
      }
    ];
    specialArgs = inputs;
  };
}
