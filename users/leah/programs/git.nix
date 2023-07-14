{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "Leah Amelia Chen";
    userEmail = "hi@pluie.me";
    signing = {
      signByDefault = true;
      key = ''
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC7uJGE2/25M4a3DIVxtnTA5INqWsFGw+49qHXaN/kqy
      '';
    };

    extraConfig = {
      init.defaultBranch = "main";
      # Not ideal, but...
      # See https://github.com/nix-community/home-manager/issues/4221
      gpg = {
        format = "ssh";
        # Use 1Password's SSH signer
        ssh.program = "${pkgs._1password-gui}/bin/op-ssh-sign";
      };
    };
  };
}
