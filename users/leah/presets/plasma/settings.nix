{
  lib,
  config,
  ...
}: {
  hm.programs.plasma.configFile = {
    kdeglobals = {
      General = {
        fixed.value = "Iosevka Nerd Font,11,-1,5,50,0,0,0,0,0";
        font.value = "Rethink Sans,11,-1,5,50,0,0,0,0,0";
        menuFont.value = "Rethink Sans,10,-1,5,50,0,0,0,0,0";
        smallestReadableFont.value = "Rethink Sans,8,-1,5,50,0,0,0,0,0";
        toolBarFont.value = "Rethink Sans,10,-1,5,50,0,0,0,0,0";
      };
      KDE = {
        SingleClick.value = false;
        widgetStyle.value = "Breeze";
      };
    };

    kwinrc = {
      Desktops = {
        Id_1.value = "d68bba52-cb75-4199-a86c-6b0595d2c54f";
        Id_2.value = "f312f93f-157d-4701-91f2-02c30d897938";
        Id_3.value = "03f3bc75-080d-4ae5-99e1-9da06b393828";
        Name_2.value = "Flake";
        Name_3.value = "Webdev";
        Number.value = 3;
        Rows.value = 1;
      };

      Tiling.padding.value = 2;

      NightColor = {
        Active.value = true;
        EveningBeginFixed.value = 2200;
        Mode.value = "Times";
        TransitionTime.value = 120;
      };

      Wayland = lib.mkIf (config.i18n.inputMethod.enabled == "fcitx5") {
        # Fcitx 5
        VirtualKeyboardEnabled.value = true;
        "InputMethod[$e]".value = "${config.i18n.inputMethod.package}/share/applications/org.fcitx.Fcitx5.desktop";
      };
    };

    # Make KRunner appear in the center of the screen, like macOS Spotlight
    krunnerrc.General.FreeFloating.value = true;

    plasmarc = {
      Theme.name.value = "default";
      Wallpapers.usersWallpapers.value = "${./wallpaper.jpg}";
    };

    kcminputrc.Mouse = {
      cursorSize.value = 32;
      cursorTheme.value = "Catppuccin-Mocha-Maroon-Cursors";
    };

    kscreenlockerrc."Greeter.Wallpaper.org.kde.image.General" = {
      Image.value = "${./wallpaper.jpg}";
      PreviewImage.value = "${./wallpaper.jpg}";
    };

    kxkbrc.Layout.Options.value = "terminate:ctrl_alt_bksp,compose:ralt";
  };
}
