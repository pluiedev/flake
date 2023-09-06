{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.pluie.user.desktop._1password;
in {
  options.pluie.user.desktop._1password.enable = mkEnableOption "1Password";

  config = mkIf cfg.enable {
    pluie.user.tools.git.signer = "${pkgs._1password-gui}/bin/op-ssh-sign";

    home.file.".ssh/config".text = ''
      Host *
        IdentityAgent ~/.1password/agent.sock
    '';

    xdg.configFile."1Password/settings/settings.json".source = ./settings.json;
  };
}
