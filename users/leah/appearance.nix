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

  hjem.users.leah = {
    ctp = {
      enable = true;
      inherit flavor accent;

      # fcitx5.withRoundedCorners = true;
    };

    packages = with pkgs; [
      breezex-cursor
      adwaita-icon-theme
    ];

    ext.programs.moor.settings.style = "catppuccin-${flavor}";
    ext.programs.vicinae.settings.theme = "catppuccin-${flavor}";
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
      lxgw-neoxihei
      fontawesome-free
      manrope
      bitter
      lxgw-neozhisong
    ];

    fontconfig = {
      defaultFonts = {
        serif = [
          "Bitter"
          "LXGW NeoZhiSong"
        ];
        sansSerif = [
          "Manrope V5"
          "LXGW Neo XiHei"
        ];
        emoji = [ "Noto Color Emoji" ];
        monospace = [
          "Iosevka"
          "LXGW Neo XiHei"
        ];
      };

      # Alias Manrope (v4, open source) to Manrope V5 (closed source)
      # I really don't know why the font designer decided to rename the
      # font altogether which really caused quite a bit of breakage
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
          <alias>
            <family>Manrope</family>
            <prefer><family>Manrope V5</family></prefer>
          </alias>
        </fontconfig>
      '';
    };
  };
}
