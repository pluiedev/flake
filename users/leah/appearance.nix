{
  pkgs,
  lib,
  ...
}:
let
  flavor = "mocha";
  accent = "maroon";

  mkUpper = str: (lib.toUpper (lib.substring 0 1 str)) + (lib.substring 1 (lib.stringLength str) str);
  fcitx5ini = pkgs.formats.iniWithGlobalSection { };
in
{
  boot.plymouth = {
    themePackages = [ pkgs.plymouth-blahaj-theme ];
    theme = "blahaj";
  };

  hjem.users.leah = {
    packages = [ pkgs.breezex-cursor ];

    files = {
      ".local/share/fcitx5/themes/catppuccin-${flavor}-${accent}".source =
        "${pkgs.catppuccin-fcitx5}/share/fcitx5/themes/catppuccin-${flavor}-${accent}";

      ".config/fcitx5/conf/classicui.conf".source = fcitx5ini.generate "fcitx5-classicui.conf" {
        globalSection = {
          Theme = "catppuccin-${flavor}-${accent}";
        };
      };

      ".config/fish/themes/Catppuccin ${mkUpper flavor}.theme".source =
        "${pkgs.catppuccin-fish}/share/fish/themes/Catppuccin ${mkUpper flavor}.theme";
    };

    rum.programs.fish.earlyConfigFiles.theme = ''
      fish_config theme choose "Catppuccin ${mkUpper flavor}"
      set -x LS_COLORS (${lib.getExe pkgs.vivid} generate catppuccin-${flavor})
    '';

    ext.programs.moar.settings.style = "catppuccin-${flavor}";

    ext.programs.vesktop.vencord.settings.themeLinks = [
      "https://catppuccin.github.io/discord/dist/catppuccin-${flavor}-${accent}.theme.css"
    ];
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
