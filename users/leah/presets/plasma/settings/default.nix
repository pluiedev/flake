{ lib, config, ... }:
{
  imports = [ ./panels.nix ];

  hm.programs.plasma = {
    enable = true;

    workspace = {
      clickItemTo = "select";
      wallpaper = "${./wallpaper.jpg}";
      cursor = {
        size = 32;
        theme = "BreezeX-Black";
      };
    };

    kwin = {
      effects = {
        blur = {
          enable = true;
          strength = 4;
          noiseStrength = 4;
        };
        cube.enable = true;
        desktopSwitching.animation = "slide";
        dimAdminMode.enable = true;
        minimization.animation = "squash";
        shakeCursor.enable = true;
        windowOpenClose.animation = "scale";
        wobblyWindows.enable = true;
      };
      nightLight = {
        enable = true;
        mode = "times";
        temperature = {
          day = 6500;
          night = 5000;
        };
        time = {
          evening = "22:00";
          morning = "06:00";
        };
        transitionTime = 120;
      };
      titlebarButtons = {
        left = [ "more-window-actions" ];
        right = [
          "minimize"
          "maximize"
          "close"
        ];
      };
      virtualDesktops = {
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

        Wayland = lib.mkIf (config.hm.i18n.inputMethod.enabled == "fcitx5") {
          # Fcitx 5
          VirtualKeyboardEnabled.value = true;
          "InputMethod[$e]".value =
            "${config.hm.i18n.inputMethod.package}/share/applications/org.fcitx.Fcitx5.desktop";
        };

        "org.kde.kdecoration2" = {
          BorderSize = "Tiny";
          BorderSizeAuto = false;
          library = "org.kde.breeze";
          theme = "Breeze";
        };

        # TODO: migrate to programs.plasma.kwin.effects
        Plugins.sheetEnabled.value = true;
      };

      # Make KRunner appear in the center of the screen, like macOS Spotlight
      krunnerrc.General.FreeFloating.value = true;

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
}
