let
  mkSystem =
    name:
    {
      profile,
      system ? null,
      modules ? [ ],
      specialArgs ? { },
    }:
    let
      profile' = profile name;
      system' = if (system != null) then system else profile'.system;
    in
    profile'.builder {
      system = system';
      specialArgs = profile'.specialArgs // specialArgs;
      modules =
        profile'.modules
        ++ modules
        ++ [
          ../machines/${name}
          {
            networking.hostName = name;
            nixpkgs.hostPlatform = system';
          }
        ];
    };
in
{
  inherit mkSystem;
  mkSystems = builtins.mapAttrs mkSystem;
}
