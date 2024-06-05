{ lib, config, ... }:
{
  imports = [ ./panels.nix ];

  hm.programs.plasma = {
    enable = true;

    fonts =
      let
        rethink = {
          family = "Rethink Sans";
          pointSize = 10;
        };
      in
      {
        general = rethink // {
          pointSize = 11;
        };
        fixedWidth = {
          family = "Iosevka Nerd Font";
          pointSize = 11;
        };
        small = rethink // {
          pointSize = 8;
        };
        toolbar = rethink;
        menu = rethink;
        windowTitle = rethink;
      };

    workspace = {
      clickItemTo = "select";
      wallpaper = "${./wallpaper.jpg}";
    };

    kwin = {
      effects.shakeCursor.enable = true;
      virtualDesktops = {
        animation = "slide";
        rows = 1;
        names = [
          "Default"
          "Flake"
          "Webdev"
        ];
      };
    };

    configFile = {
      kwinrc = {
        Tiling.padding.value = 2;

        NightColor = {
          Active.value = true;
          EveningBeginFixed.value = 2200;
          Mode.value = "Times";
          TransitionTime.value = 120;
        };

        Wayland = lib.mkIf (config.hm.i18n.inputMethod.enabled == "fcitx5") {
          # Fcitx 5
          VirtualKeyboardEnabled.value = true;
          "InputMethod[$e]".value = "${config.hm.i18n.inputMethod.package}/share/applications/org.fcitx.Fcitx5.desktop";
        };

        "org.kde.kdecoration2" = {
          BorderSize = "Tiny";
          BorderSizeAuto = false;
          library = "org.kde.breeze";
          theme = "Breeze";
        };

        Plugins = {
          cubeEnabled.value = true;
          dimscreenEnabled.value = true;
          shakecursorEnabled.value = true;
          sheetEnabled.value = true;
          wobblywindowsEnabled.value = true;
        };
      };

      # Make KRunner appear in the center of the screen, like macOS Spotlight
      krunnerrc.General.FreeFloating.value = true;

      kcminputrc.Mouse.cursorSize.value = 32;

      kxkbrc.Layout.Options.value = "terminate:ctrl_alt_bksp,compose:ralt";

      spectaclerc = {
        General = {
          autoSaveImage = true;
          clipboardGroup = "PostScreenshotCopyImage";
          onLaunchAction = "UseLastUsedCapturemode"; # Pressing the Spectacle shortcut while Spectacle is NOT running
          launchAction = "UseLastUsedCapturemode"; # Pressing the Spectacle shortcut while Spectacle is running
        };
        ImageSave = {
          imageFilenameTemplate = "<yyyy>-<MM>-<dd>_<hh>-<mm>-<ss>";
          imageSaveLocation = "file:///home/leah/Pictures/screenshots/";
        };
        VideoSave = {
          videoFilenameTemplate = "<yyyy>-<MM>-<dd>_<hh>-<mm>-<ss>";
          videoSaveLocation = "file:///home/leah/Videos/screencasts/";
        };
      };
    };
  };

  hm.programs.konsole.enable = true;
}
