{
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
        widgets = [
          {
            systemTray = {
              icons.scaleToFit = true;
              items = {
                shown = ["org.kde.plasma.battery"];
                hidden = ["org.kde.plasma.brightness" "org.kde.plasma.clipboard"];
                configs.battery.showPercentage = true;
              };
            };
          }
        ];
      }
    ];
}
