{pkgs, ...}: {
  programs = {
    exa = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
    };

    fzf.enable = true;
    gh.enable = true;

    git = {
      enable = true;
      extraConfig = {
        init.defaultBranch = "main";
        user = {
          email = "hi@pluie.me";
          name = "Leah Amelia Chen";
          # Don't worry, this is the public key xD
          signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC7uJGE2/25M4a3DIVxtnTA5INqWsFGw+49qHXaN/kqy";
        };
        # Use 1Password's SSH signer
        gpg = {
          format = "ssh";
          ssh.program = "${pkgs._1password-gui}/bin/op-ssh-sign";
        };
        commit.gpgsign = true;
      };
    };

    hyfetch.enable = true;

    fish.enable = true;

    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        add_newline = true;
      };
    };

    obs-studio.enable = true;
    ripgrep.enable = true;

    thunderbird = {
      enable = true;
      profiles.leah.isDefault = true;
    };
  };
}
