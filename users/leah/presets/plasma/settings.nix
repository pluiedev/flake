{
  lib,
  config,
  ...
}: {
  hm.programs.plasma.configFile = {
    kdeglobals = {
      General = {
        fixed = "Iosevka Nerd Font,11,-1,5,50,0,0,0,0,0";
        font = "Rubik,11,-1,5,50,0,0,0,0,0";
        menuFont = "Rubik,10,-1,5,50,0,0,0,0,0";
        smallestReadableFont = "Rubik,8,-1,5,50,0,0,0,0,0";
        toolBarFont = "Rubik,10,-1,5,50,0,0,0,0,0";
      };
      KDE = {
        SingleClick = false;
        widgetStyle = "Breeze";
      };
      KScreen.ScaleFactor = 1.25;
    };

    kwinrc = {
      Desktops = {
        Id_1 = "d68bba52-cb75-4199-a86c-6b0595d2c54f";
        Id_2 = "f312f93f-157d-4701-91f2-02c30d897938";
        Id_3 = "03f3bc75-080d-4ae5-99e1-9da06b393828";
        Name_2 = "Flake";
        Name_3 = "Webdev";
        Number = 3;
        Rows = 1;
      };

      Tiling.padding = 2;

      NightColor = {
        Active = true;
        EveningBeginFixed = 2200;
        Mode = "Times";
        TransitionTime = 120;
      };

      Wayland = lib.mkIf (config.i18n.inputMethod.enabled == "fcitx5") {
        # Fcitx 5
        VirtualKeyboardEnabled = true;
        "InputMethod[$e]" = "${config.i18n.inputMethod.package}/share/applications/org.fcitx.Fcitx5.desktop";
      };

      Xwayland.Scale = 1.25;
    };

    # Make KRunner appear in the center of the screen, like macOS Spotlight
    krunnerrc.General.FreeFloating = true;

    plasmarc = {
      Theme.name = "default";
      Wallpapers.usersWallpapers = "${./wallpaper.jpg}";
    };

    kcminputrc.Mouse = {
      cursorSize = 32;
      cursorTheme = "Catppuccin-Mocha-Maroon-Cursors";
    };

    kscreenlockerrc."Greeter.Wallpaper.org.kde.image.General" = {
      Image = "${./wallpaper.jpg}";
      PreviewImage = "${./wallpaper.jpg}";
    };

    kxkbrc.Layout.Options = "terminate:ctrl_alt_bksp,compose:ralt";
  };
}
