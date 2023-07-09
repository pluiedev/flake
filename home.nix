{ config, pkgs, ... }:

{
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

  # The home.packages option allows you to install Nix packages into your
  # environment.
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
    deadnix
    mold
    perl
    rbenv
    temurin-bin-17
    #temurin-bin-8
    pre-commit
    python3Full
    statix
    stylua

    # Command-line apps
    exa
    fzf
    gh
    helix
    hyfetch
    just
    nvimpager
    nethack
    ripgrep
    ripgrep-all
    tectonic
    zi
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/leah/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs = {
    home-manager.enable = true;

    firefox = {
      enable = true;
    };
    neovim = {
      enable = true;
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      autocd = true;
      # zplug.enable = true;
    };
  };
}

