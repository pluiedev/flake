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
