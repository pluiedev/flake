{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "Leah Amelia Chen";
    userEmail = "hi@pluie.me";

    signing.signByDefault = true;
    signing.ssh = {
      enable = true;
      key = ''
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC7uJGE2/25M4a3DIVxtnTA5INqWsFGw+49qHXaN/kqy
      '';
      # Use 1Password's SSH signer
      program = "${pkgs._1password-gui}/bin/op-ssh-sign";
    };

    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };
}
