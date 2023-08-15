{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.pluie.desktop._1password;
in {
  options.pluie.desktop._1password.enable = mkEnableOption "1Password";

  config = mkIf cfg.enable {
    programs = {
      _1password.enable = true;
      _1password-gui = {
        enable = true;
        polkitPolicyOwners = [config.pluie.user.name];
      };
    };

    pluie.tools.git.signer = "${pkgs._1password-gui}/bin/op-ssh-sign";

    pluie.user.config.home.file.".ssh/config".text = ''
      Host *
        IdentityAgent ~/.1password/agent.sock
    '';
  };
}
