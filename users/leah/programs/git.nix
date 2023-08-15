{
  user,
  lib,
  pkgs,
  ...
}: let
  primaryEmail = builtins.attrNames (lib.filterAttrs (_: v: v.primary) user.email.accounts);
in {
  programs.git = {
    enable = true;
    userName = user.fullName;
    userEmail = lib.mkIf (primaryEmail != []) (builtins.head primaryEmail);

    signing = {
      signByDefault = true;
      format = "ssh";
      key = ''
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC7uJGE2/25M4a3DIVxtnTA5INqWsFGw+49qHXaN/kqy
      '';
      # Use 1Password's SSH signer
      program = "${pkgs._1password-gui}/bin/op-ssh-sign";
    };

    extraConfig.init.defaultBranch = "main";
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  # Configure 1Password's SSH signer
  home.file.".ssh/config".text = ''
    Host *
      IdentityAgent ~/.1password/agent.sock
  '';
}
