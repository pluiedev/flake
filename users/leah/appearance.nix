{
  pkgs,
  lib,
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

  hjem.users.leah = {
    ctp = {
      enable = true;
      inherit flavor accent;
    };

    packages = [ pkgs.breezex-cursor ];

    rum.programs.fish.earlyConfigFiles.ctp-eza = ''
      set -x LS_COLORS (${lib.getExe pkgs.vivid} generate catppuccin-${flavor})
    '';

    ext.programs.moar.settings.style = "catppuccin-${flavor}";
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
