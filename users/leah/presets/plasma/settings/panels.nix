{lib, ...}: {
  hm.programs.plasma.panels = let
    base = {
      hiding = "dodgewindows";
      floating = true;
      height = 36;
      location = "top";
      lengthMode = "fit";
    };
  in
    map (p: base // p) [
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
          {
            systemMonitor = {
              title = "CPU Usage";
              sensors = [
                {
                  name = "cpu/all/usage";
                  color = "250,179,135"; # Peach
                }
              ];
              totalSensors = ["cpu/all/usage"];
              textOnlySensors = ["cpu/all/averageTemperature" "cpu/all/averageFrequency"];
            };
          }
          {
            systemMonitor = {
              title = "GPU Usage";
              sensors = [
                {
                  name = "gpu/gpu1/usage";
                  color = "180,190,254"; # Lavender
                }
              ];
              totalSensors = ["gpu/gpu1/usage"];
              textOnlySensors = ["gpu/gpu1/temperature" "gpu/gpu1/frequency" "gpu/gpu1/power" "gpu/gpu1/usedVram" "gpu/gpu1/totalVram"];
            };
          }
          {
            systemMonitor = {
              title = "Memory Usage";
              sensors = [
                {
                  name = "memory/physical/usedPercent";
                  color = "166,227,161"; # Green
                }
              ];
              totalSensors = ["memory/physical/usedPercent"];
              textOnlySensors = ["memory/physical/used" "memory/physical/total"];
            };
          }
        ];
      }
      {
        alignment = "center";
        widgets = [
          {
            digitalClock = {
              date.format.custom = "d MMM ''yy / ddd";
              time.format = "24h";
              timeZone = {
                selected = ["Europe/Berlin" "Asia/Shanghai"];
                changeOnScroll = true;
                format = "city";
              };
            };
          }
        ];
      }
      {
        alignment = "right";
        widgets = ["org.kde.plasma.systemtray"];

        extraSettings = ''
          // Yes, trying to customize the system tray is fucking cursed.

          // Why can't we just use panelWidgets["org.kde.plasma.systemtray"], you say?
          // Well, that's because SOMEHOW the widget you get from that is DIFFERENT
          // from the REAL system tray widget! *sigh*

          for (const wid of panel.widgets(["org.kde.plasma.systemtray"])) {
            const tray = desktopById(wid.readConfig("SystrayContainmentId"));
            if (!tray) continue; // if somehow the containment doesn't exist

            tray.writeConfig("hiddenItems", [
              "org.kde.plasma.brightness",
              "org.kde.plasma.clipboard",
            ]);

            // At least customizing subwidgets is blissfully simple.
            const battery = tray.addWidget("org.kde.plasma.battery");
            battery.writeConfig("showPercentage", true);
          }
        '';
      }
    ];
}
