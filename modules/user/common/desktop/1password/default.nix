{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.pluie.user.desktop._1password;

  # Converts an attrset like { p = 4; a.b.c = { d.e.f = 3; e = 5; }; }
  # to another attrset like { p = 4; "a.b.c.d.e.f" = 3; "a.b.c.e" = 5; }
  pathify = let
    inherit (lib) flatten mapAttrsToList nameValuePair;
    pathify' = name: value:
      if (builtins.typeOf value == "set")
      then
        flatten (mapAttrsToList (
            n: v: let
              pfx =
                if (name != "")
                then "${name}."
                else "";
            in
              pathify' "${pfx}${n}" v
          )
          value)
      else nameValuePair name value;
  in
    v: builtins.listToAttrs (pathify' "" v);
in {
  options.pluie.user.desktop._1password = {
    enable = mkEnableOption "1Password";
    autostart = mkEnableOption "autostarting 1Password";

    settings = mkOption {
      type = types.attrsOf types.anything;
      default = {};
    };

    enableSshAgent = mkOption {
      type = types.bool;
      default = cfg.settings.sshAgent.enabled or false;
    };
  };

  config = let
    inherit (osConfig.programs._1password-gui) package;
  in
    mkIf cfg.enable {
      assertions = [
        {
          assertion = osConfig.pluie.desktop._1password.enable;
          message = "1Password must be enabled system-wide first";
        }
      ];

      home.packages = mkIf cfg.autostart [
        (pkgs.makeAutostartItem {
          name = "1password";
          inherit package;
        })
      ];

      pluie.user.tools.git.signer = "${package}/bin/op-ssh-sign";

      home.file.".ssh/config".text = mkIf cfg.enableSshAgent ''
        Host *
          IdentityAgent ~/.1password/agent.sock
      '';

      xdg.configFile."1Password/settings/settings.json".text = builtins.toJSON (pathify ({version = 1;} // cfg.settings));
    };
}
