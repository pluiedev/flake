{
  config,
  pkgs,
  lib,
  ...
}: let
  realName = "Leah Amelia Chen";
in {
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
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    gimp-with-plugins
    inkscape-with-extensions
    mongodb-compass
    prismlauncher
    steam
    vlc

    # System utilities
    ffmpeg_6
    pipewire
    zerotierone
    (nerdfonts.override {fonts = ["Iosevka"];})

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
    nethack
    nvd
    nvimpager
    starship
    tectonic
    xclip
    zi
  ];

  xdg.enable = true;
  xdg.configFile.nvim = {
    source = ./nvim;
    recursive = true;
  };

  accounts.email.accounts = let
    inherit (builtins) match listToAttrs mapAttrs;
    inherit (lib) zipListsWith filterAttrs;
    # Shoutout to getchoo who figured this out for me
    mkEmailAccounts = mapAttrs (name: account:
      rec {
        imap = {
          host = "imap.migadu.com";
          port = 993;
        };
        smtp = {
          host = "smtp.migadu.com";
          port = 465;
        };
        address = "${name}@pluie.me";
        userName = address; # Use the address as the IMAP/SMTP username by default

        passwordCommand =
          if account._1passItemId != null
          then "/run/wrappers/bin/op item get --fields label=password ${account._1passItemId}"
          else null;

        thunderbird.enable = true;
      }
      // (filterAttrs (name: _: name != "_1passItemId") account));
  in
    mkEmailAccounts {
      hi = {
        primary = true;

        inherit realName;
        _1passItemId = "fjutji565zipohkgsowe3c3nqq";
      };
      acc = {
        realName = "${realName} [accounts]";
        _1passItemId = "s6b5a7cf236jmpthkbdc4yzacu";
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

      # Janky workaround
      # https://github.com/nix-community/home-manager/issues/1586
      package = pkgs.firefox.override {
        cfg = {
          enablePlasmaBrowserIntegration = true;
        };
      };

      profiles.leah = {
        isDefault = true;
        name = "Leah";

        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          augmented-steam
          auto-tab-discard
          darkreader
          decentraleyes
          disconnect
          furiganaize
          languagetool
          onepassword-password-manager
          plasma-integration
          pronoundb
          protondb-for-steam
          refined-github
          rust-search-extension
          search-by-image
          sponsorblock
          terms-of-service-didnt-read
          ublock-origin
          unpaywall
          vencord-web
          wayback-machine
          youtube-nonstop
        ];

        search.default = "DuckDuckGo";
        search.force = true;
        search.engines = let
          mkParams = params:
            map
            (name: {
              inherit name;
              value = builtins.getAttr name params;
            })
            (builtins.attrNames params);
        in {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = mkParams {
                  type = "packages";
                  query = "{searchTerms}";
                };
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
          };
          "NixOS Wiki" = {
            urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
            iconUpdateURL = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = ["@nw"];
          };
          "Wiktionary" = {
            urls = [
              {
                template = "https://en.wiktionary.org/wiki/Special:Search";
                params = mkParams {search = "{searchTerms}";};
              }
            ];
            icon = "https://en.wiktionary.org/favicon.ico";
            definedAliases = ["@nw"];
          };
        };
      };
    };

    fzf.enable = true;
    gh.enable = true;

    git = {
      enable = true;
      extraConfig = {
        init.defaultBranch = "main";
        user = {
          email = "hi@pluie.me";
          name = realName;
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
