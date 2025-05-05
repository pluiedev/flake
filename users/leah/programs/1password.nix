{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs = {
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      package = pkgs._1password-gui-beta;

      # Unlock 1Pass via PolKit
      polkitPolicyOwners = [ "leah" ];
    };
  };

  # Add 1Pass as SSH agent
  hjem.users.leah = {
    environment.sessionVariables.SSH_AUTH_SOCK = "${config.hjem.users.leah.directory}/.1password/agent.sock";
  };
}
