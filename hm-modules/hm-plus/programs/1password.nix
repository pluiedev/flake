{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkIf
    mkEnableOption
    mkPackageOption
    optional
    getExe'
    ;

  cfg = config.programs._1password;
in
{
  options.programs._1password = {
    enable = mkEnableOption "1Password";

    package = mkPackageOption pkgs "1Password" { default = [ "_1password-gui" ]; };

    autostart = mkEnableOption "autostarting 1Password";

    enableSshAgent = mkEnableOption "1Password's SSH agent";
  };
  config = mkIf cfg.enable {
    home.packages =
      [ cfg.package ]
      ++ optional cfg.autostart (
        pkgs.makeAutostartItem {
          name = "1password";
          inherit (cfg) package;
        }
      );

    programs = mkIf cfg.enableSshAgent {
      git.signer = getExe' cfg.package "op-ssh-sign";
      ssh.enable = mkDefault true;
      ssh.extraConfig = "IdentityAgent ${config.home.homeDirectory}/.1password/agent.sock";
    };

    # Some tools like Jujutsu don't care about ~/.ssh/config, so we have to set this manually
    home.sessionVariables.SSH_AUTH_SOCK = mkIf cfg.enableSshAgent "${config.home.homeDirectory}/.1password/agent.sock";
  };
}
