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
      theme = "default"; # Actually Catppuccin
      colorScheme = "CatppuccinMochaMaroon";
      cursorTheme = "Catppuccin-Mocha-Maroon-Cursors";
      lookAndFeel = "org.kde.breezedark.desktop";
      iconTheme = "breeze-dark";
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
    };
  };

  hm.programs.konsole = {
    enable = true;
    defaultProfile = "Catppuccin";
    profiles.catppuccin = {
      name = "Catppuccin";
      colorScheme = "Catppuccin-Mocha";
      font = {
        name = "Iosevka Nerd Font";
        size = 12;
      };
    };
  };
}
