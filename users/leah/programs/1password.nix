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
    files.".ssh/config".text = ''
      Host *
        IdentityAgent ${config.hjem.users.leah.directory}/.1password/agent.sock
    '';

    ext.programs.git.settings.gpg.ssh.program =
      lib.getExe' config.programs._1password-gui.package "op-ssh-sign";
  };
}
