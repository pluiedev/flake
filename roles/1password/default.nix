{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.roles._1password;

  inherit (config.programs._1password-gui) package;
in {
  options.roles._1password = {
    enable = mkEnableOption "1Password";
    autostart = mkEnableOption "autostarting 1Password";

    settings = mkOption {
      type = types.nullOr (types.attrsOf types.anything);
      default = null;
    };

    sshAgent.enable =
      mkEnableOption "1Password's SSH signing agent"
      // {
        default = cfg.settings.sshAgent.enabled or false;
      };
  };

  config = mkIf cfg.enable {
    roles.git.signing.signer = mkIf cfg.sshAgent.enable "${package}/bin/op-ssh-sign";

    hm.home.file.".ssh/config" = mkIf cfg.sshAgent.enable {
      text = ''
        Host *
          IdentityAgent ~/.1password/agent.sock
      '';
    };
  };
}
