{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf mkMerge mkOption mkEnableOption mkPackageOption optional;
  cfg = config.programs._1password;

  format = pkgs.formats.json {};

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
in {
  options.programs._1password = {
    enable = mkEnableOption "1Password";

    package = mkPackageOption pkgs "1Password" {
      default = ["_1password-gui"];
    };

    autostart = mkEnableOption "autostarting 1Password";

    settings = mkOption {
      inherit (format) type;
      default = {};
      description = ''
        Configuration written to {file}`$XDG_CONFIG_HOME/1Password/settings/settings.json`.

        Note that setting `sshAgent.enabled` in these settings also enables the 1Password SSH agent automatically.
      '';
    };

    sshAgent.enable =
      mkEnableOption "1Password's SSH agent, enabled by default if `programs._1password.settings.sshAgent.enabled` is set to true"
      // {
        default = cfg.settings.sshAgent.enabled ? false;
      };
  };
  config = mkIf cfg.enable (mkMerge [
    {
      home.packages =
        [cfg.package]
        ++ optional cfg.autostart (pkgs.makeAutostartItem {
          name = "1password";
          inherit (cfg) package;
        });

      xdg.configFile."1Password/settings/settings.json".source = format.generate "1password-settings.json" (
        pathify ({version = 1;} // cfg.settings)
      );
    }
    (mkIf cfg.sshAgent.enable {
      programs.git.signing.signer = lib.getExe cfg.package "op-ssh-sign";
      programs.ssh.extraConfig = "IdentityAgent ${config.home.homeDirectory}/.1password/agent.sock";
    })
  ]);
}
