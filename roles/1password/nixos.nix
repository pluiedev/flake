{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf optional;
  cfg = config.roles._1password;
in {
  config = let
    inherit (config.programs._1password-gui) package;

    # Converts an attrset like { p = 4; a.b.c = { d.e.f = 3; e = 5; }; }
    # to another attrset like { p = 4; "a.b.c.d.e.f" = 3; "a.b.c.e" = 5; }
    pathify = let
      inherit (lib) flatten mapAttrsToList nameValuePair;
      inherit (builtins) isAttrs listToAttrs;

      pathify' = name: value:
        if isAttrs value
        then
          flatten (mapAttrsToList (n:
            pathify' (
              if name != ""
              then "${name}.${n}"
              else n
            ))
          value)
        else [(nameValuePair name value)];
    in
      v:
        if isAttrs v
        then listToAttrs (pathify' "" v)
        else v;
  in
    mkIf cfg.enable {
      programs = {
        _1password.enable = true;
        _1password-gui = {
          inherit (cfg) package;
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
