{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf getExe optional;
  cfg = config.roles._1password;
in {
  config = let
    inherit (config.programs._1password-gui) package;

    # Converts an attrset like { p = 4; a.b.c = { d.e.f = 3; e = 5; }; }
    # to another attrset like { p = 4; "a.b.c.d.e.f" = 3; "a.b.c.e" = 5; }
    pathify = let
      inherit (lib) flatten mapAttrsToList nameValuePair;
      pathify' = name: value:
        if (builtins.typeOf value == "set")
        then
          flatten (mapAttrsToList (
              n:
                if (name != "")
                then pathify' "${name}.${n}"
                else pathify' n
            )
            value)
        else nameValuePair name value;
    in
      v: builtins.listToAttrs (pathify' "" v);
  in
    mkIf cfg.enable {
      programs = {
        _1password.enable = true;
        _1password-gui = {
          enable = true;
          polkitPolicyOwners = optional config.roles.base.canSudo config.roles.base.username;
        };
      };

      hm = {
        home.packages = mkIf cfg.autostart [
          (pkgs.makeAutostartItem {
            name = "1password";
            inherit package;
          })
        ];

        xdg.configFile."1Password/settings/settings.json" = mkIf (cfg.settings != null) {
          text = builtins.toJSON (pathify ({version = 1;} // cfg.settings));
        };
      };
    };
}
