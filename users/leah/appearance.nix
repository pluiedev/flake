{
  pkgs,
  ...
}:
let
  flavor = "mocha";
  accent = "maroon";
in
{
  boot.plymouth = {
    themePackages = [ pkgs.plymouth-blahaj-theme ];
    theme = "blahaj";
  };

  boot.loader.limine.style = {
    wallpapers = [ ];
    graphicalTerminal = {
      palette = "1e1e2e;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4";
      brightPalette = "585b70;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4";
      background = "1e1e2e";
      foreground = "cdd6f4";
      brightBackground = "585b70";
      brightForeground = "cdd6f4";
      font.scale = "2x2";
    };
  };

  # programs.dconf.profiles.user.databases = [
  #   {
  #     settings = {
  #       "org/gnome/desktop/interface" = {
  #         font-name = "DM Sans 13";
  #         gtk-theme = "Adwaita";
  #         icon-theme = "Adwaita";
  #         color-scheme = "prefer-dark";
  #         # Not exactly maroon, but close enough
  #         accent-color = "pink";
  #         cursor-theme = "BreezeX-Dark";
  #         cursor-size = lib.gvariant.mkInt32 32;
  #       };
  #     };
  #   }
  # ];

  hjem.users.leah = {
    ctp = {
      enable = true;
      inherit flavor accent;

      # fcitx5.withRoundedCorners = true;
    };

    packages = with pkgs; [
      breezex-cursor
      adw-gtk3
      adwaita-icon-theme
    ];

    ext.programs.moar.settings.style = "catppuccin-${flavor}";
  };

  programs.vivid = {
    enable = true;
    theme = "catppuccin-${flavor}";
  };

  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      iosevka
      noto-fonts-color-emoji
      libertinus
      i-dot-ming
      lxgw-neoxihei
      dm-sans-unstable
    ];

    fontconfig = {
      defaultFonts = {
        serif = [
          "I.Ming"
        ];
        sansSerif = [
          "DM Sans"
          "LXGW Neo XiHei"
        ];
        emoji = [ "Noto Color Emoji" ];
        monospace = [
          "Iosevka"
          "LXGW Neo XiHei"
        ];
      };
    };
  };
}
