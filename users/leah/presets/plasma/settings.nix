{
  lib,
  config,
  ...
}: {
  hm.programs.plasma = {
    enable = true;

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
        names = ["Default" "Flake" "Webdev"];
      };
    };

    panels = let
      applyBase = {extraSettings ? "", ...} @ p: let
        rest = builtins.removeAttrs p ["extraSettings"];
      in
        {
          hiding = "dodgewindows";
          floating = true;
          height = 36;
          location = "top";

          extraSettings = ''
            panel.lengthMode = "fit"
            ${extraSettings}
          '';
        }
        // rest;

      mkSysMonitor = {
        title,
        sensorColors,
        totalSensors,
        sensors ? totalSensors,
        textOnlySensors,
      }: let
        mkList = ids: "[${lib.concatMapStringsSep ", " (x: "\\\"${x}\\\"") ids}]";
      in {
        name = "org.kde.plasma.systemmonitor";
        config = {
          Appearance = {inherit title;};
          SensorColors = sensorColors;
          Sensors = {
            highPrioritySensorIds = mkList sensors;
            lowPrioritySensorIds = mkList textOnlySensors;
            totalSensors = mkList totalSensors;
          };
        };
      };
    in
      map applyBase [
        {
          height = 60;
          location = "bottom";
          alignment = "center";
          widgets = [
            {
              name = "org.kde.plasma.kickoff"; # Application Launcher
              config.General = {
                primaryActions = "2"; # Custom buttons
                systemFavorites = ["lock-screen" "logout" "suspend" "reboot" "shutdown"];
                showActionButtonCaptions = "false";
              };
            }
            "org.kde.plasma.icontasks" # Icons-only Task Manager
          ];
        }
        {
          alignment = "left";
          widgets = [
            "org.kde.plasma.showdesktop"
            (mkSysMonitor {
              title = "CPU Usage";
              sensorColors."cpu/all/usage" = "250,179,135"; # Peach
              totalSensors = ["cpu/all/usage"];
              textOnlySensors = ["cpu/all/averageTemperature" "cpu/all/averageFrequency"];
            })
            (mkSysMonitor {
              title = "GPU Usage";
              sensorColors."gpu/gpu1/usage" = "180,190,254"; # Lavender
              totalSensors = ["gpu/gpu1/usage"];
              textOnlySensors = ["gpu/gpu1/temperature" "gpu/gpu1/frequency" "gpu/gpu1/power" "gpu/gpu1/usedVram" "gpu/gpu1/totalVram"];
            })
            (mkSysMonitor {
              title = "Memory Usage";
              sensorColors."memory/physical/usedPercent" = "166,227,161"; # Green
              totalSensors = ["memory/physical/usedPercent"];
              textOnlySensors = ["memory/physical/used" "memory/physical/total"];
            })
          ];
        }
        {
          alignment = "center";
          widgets = [
            {
              name = "org.kde.plasma.digitalclock";
              config.Appearance = {
                dateFormat = "custom";
                customDateFormat = "dd MMM ''yy / ddd";
                selectedTimeZones = ["Europe/Berlin" "Asia/Shanghai"];
                wheelChangesTimezone = "true";
                displayTimezoneFormat = "FullText";
                use24hFormat = "2"; # 24-hour
              };
            }
          ];
        }
        {
          alignment = "right";
          widgets = ["org.kde.plasma.systemtray"];

          # Doesn't really work since a newly created system tray doesn't have its containment ID set.
          #extraSettings = ''
          #  // Yes, trying to customize the system tray is fucking cursed.
          #  const systemTray = desktopById(panelWidgets["org.kde.plasma.systemtray"].readConfig("SystrayContainmentId"));
          #  systemTray.writeConfig("hiddenItems", ["org.kde.plasma.brightness", "org.kde.plasma.clipboard"]);

          #  const battery = systemTray.widgets(["org.kde.plasma.battery"])[0];
          #  battery.writeConfig("showPercentage", true);
          #'';
        }
      ];

    configFile = {
      kdeglobals = {
        General = {
          fixed.value = "Iosevka Nerd Font,11,-1,5,50,0,0,0,0,0";
          font.value = "Rethink Sans,11,-1,5,50,0,0,0,0,0";
          menuFont.value = "Rethink Sans,10,-1,5,50,0,0,0,0,0";
          smallestReadableFont.value = "Rethink Sans,8,-1,5,50,0,0,0,0,0";
          toolBarFont.value = "Rethink Sans,10,-1,5,50,0,0,0,0,0";
        };
      };

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
