inputs @ {
  nixpkgs,
  home-manager,
  nix-darwin,
  ...
}: rec {
  mkSystem = name: {
    profile,
    system ? null,
    modules ? [],
    specialArgs ? {},
  }: let
    profile' = profile name;
    system' =
      if (system != null)
      then system
      else profile'.system;
  in
    profile'.builder {
      system = system';
      specialArgs = profile'.specialArgs // specialArgs;
      modules =
        profile'.modules
        ++ modules
        ++ [
          {
            networking.hostName = name;
            nixpkgs.hostPlatform = system';
          }
        ];
    };
  mkSystems = builtins.mapAttrs mkSystem;

  personal = name: {
    system = "x86_64-linux";
    builder = nixpkgs.lib.nixosSystem;

    modules = [
      home-manager.nixosModules.home-manager

      ./${name}
      ../roles/nixos.nix
      ../users/personal.nix

      {system.stateVersion = "23.11";}
    ];
    specialArgs = inputs;
  };

  personal-mac = name: {
    system = "x86_64-darwin";
    builder = nix-darwin.lib.darwinSystem;

    modules = [
      home-manager.darwinModules.home-manager

      ./${name}
      ../roles/darwin.nix
      ../users/personal.nix

      {system.stateVersion = 4;}
    ];
    specialArgs = inputs;
  };
}
