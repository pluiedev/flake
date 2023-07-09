{ config, pkgs, lib, ... }:


let
  mainAddress = "hi@pluie.me";
  realName = "Leah Amelia Chen";
in {
  xdg.enable = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "leah";
  home.homeDirectory = "/home/leah";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # Apps
    _1password-gui
    _1password
    (discord.override { withOpenASAR = true; withVencord = true; })
    gimp-with-plugins
    inkscape-with-extensions
    mongodb-compass
    prismlauncher
    steam
    vlc

    # System utilities
    fcitx5-with-addons
    fcitx5-mozc
    fcitx5-rime
    ffmpeg_6
    pipewire
    zerotierone
    (nerdfonts.override { fonts = ["Iosevka"]; })

    # Coding utilities
    alejandra
    black
    clang_16
    deadnix
    deno
    mold
    perl
    rbenv
    temurin-bin
    pre-commit
    python3Full
    nodePackages_latest.nodejs
    nodePackages_latest.pyright
    ruff
    rustup
    statix
    stylua

    # Command-line apps
    just
    nvimpager
    nethack
    tectonic
    xclip
    zi
  ];

  #xdg.configFile.nvim = {
  #  source = ./nvim;
  #  recursive = true;
  #};

  accounts.email.accounts = let 
    # Shoutout to getchoo who figured this out for me
    mkEmailAccounts = builtins.mapAttrs (_: account: {
      imap.host = "imap.migadu.com";
      smtp.host = "smtp.migadu.com";
      userName = account.address; # Use the address as the IMAP/SMTP username by default
      thunderbird.enable = true;
    } // account);

  in mkEmailAccounts {
    main = {
      inherit realName;
      primary = true;
      address = mainAddress;
    };
    accounts = {
      address = "acc@pluie.me";
      realName = "${realName} [accounts]";
    };
  };

  programs = {
    home-manager.enable = true;

    exa = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
    };
    firefox = {
      enable = true;
    };
    fzf.enable = true;
    gh.enable = true;

    git = {
      enable = true;
      extraConfig = {
        init.defaultBranch = "main";
        user = {
          email = mainAddress;
          name = realName;
          # Don't worry, this is the public key xD
          signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC7uJGE2/25M4a3DIVxtnTA5INqWsFGw+49qHXaN/kqy";
        };
        # Use 1Password's SSH signer
        gpg = {
          format = "ssh";
          ssh.program = "/etc/profiles/per-user/leah/bin/op-ssh-sign";
        };
        commit.gpgsign = true;
      };
    };
    hyfetch.enable = true;

    fish = {
      enable = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    obs-studio.enable = true;
    ripgrep.enable = true;

    thunderbird = {
      enable = true;
      profiles.leah.isDefault = true;
    };
  };
}

