{
  pkgs,
  system,
  osConfig,
  ...
}: {
  imports = [
    ./firefox.nix
    ./nvim
  ];

  home.packages = with pkgs; [
    # Apps
    gimp-with-plugins
    inkscape-with-extensions
    kdenlive
    libreoffice-qt
    prismlauncher
    vlc

    # Command-line apps
    any-nix-shell
    just
    nvd
    xclip

    # Misc
    krunner-nix

    (pkgs.makeAutostartItem {
      name = "1password";
      inherit (osConfig.programs._1password-gui) package;
    })
  ];

  # Use the 1Password CLI plugins
  home.sessionVariables.OP_PLUGIN_ALIASES_SOURCED = "1";
  programs.fish.shellAliases = {
    cargo = "op plugin run -- cargo";
    gh = "op plugin run -- gh";
  };

  programs = {
    eza = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    hyfetch = {
      enable = true;
      settings = {
        preset = "lesbian";
        mode = "rgb";
        lightness = 0.60;
        color_align.mode = "horizontal";
      };
    };

    obs-studio.enable = true;
    ripgrep.enable = true;
  };
}
