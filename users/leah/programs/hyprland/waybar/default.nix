{
  osConfig,
  pkgs,
  lib,
  ...
}: {
  programs.waybar = {
    enable = true;

    style = builtins.readFile ./style.css;

    settings = [
      {
        layer = "top";
        position = "bottom";

        modules-left = ["tray"];
        modules-center = ["wlr/taskbar"];
        modules-right = ["pulseaudio" "backlight" "battery" "bluetooth" "network"];

        tray = {
          icon-size = 20;
          spacing = 10;
        };
        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 20;
          tooltip-format = "{title}";
          on-click = "activate";
          ignore-list = ["kitty"];
        };
        pulseaudio = {
          format = "{icon} {volume}%   {format_source}";
          format-muted = "󰝟";
          format-source = "󰍬 {volume}%";
          format-source-muted = "󰍭";
          reverse-scrolling = true;
          on-click = lib.getExe pkgs.pavucontrol;
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["󰕿" "" "󰕾"];
          };
        };
        backlight = {
          device = "intel_backlight";
          format = "{icon} {percent}%";
          format-icons = ["󱩎" "󱩏" "󱩐" "󱩑" "󱩒" "󱩓" "󱩔" "󱩕" "󱩖" "󰛨"];
        };
        battery = {
          interval = 1;
          states = {
            full = 95;
            not-quite-full = 65;
            warning = 25;
            critical = 10;
          };

          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-critical = "󰂃 {capacity}%";
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };
        bluetooth = {
          format = "";
          format-disabled = "󰂲";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_alias} <small>{device_battery_percentage}%</small>";
          tooltip-format-connected = "{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
        };
        network = {
          format = "󰌘";
          format-disconnect = "󰌙 {essid}";
          format-ethernet = "󰈀";
          format-wifi = "󰖩  {essid}";
          tooltip = true;
          tooltip-format-wifi = "󰢾 {signalStrength}% 󰛶 {bandwidthUpBytes} 󰛴 {bandwidthDownBytes}";
        };
      }
      {
        layer = "top";
        position = "top";

        modules-left = ["hyprland/workspaces"];
        modules-center = ["clock"];
        modules-right = ["cpu" "custom/gpu" "memory" "custom/wlogout"];

        clock = {
          interval = 1;
          timezones = ["Europe/Berlin" "Asia/Shanghai"];
          format = "{:<span color='#7f849c'><span color='#f38ba8'>%R</span> | <span color='#fab387'>%a</span> <span color='#f9e2af'>%d</span>.<span color='#a6e3a1'>%m</span>.<span color='#89dceb'>%y</span> | <span color='#b4befe'>%z</span></span>}";
          tooltip-format = "<tt><span color='#7f849c'>{:<span color='#f38ba8'>%T</span> | <span color='#fab387'>%A</span>, <span color='#f9e2af'>%e</span> <span color='#a6e3a1'>%b</span> <span color='#89dceb'>%Y</span> | <span color='#b4befe'>UTC%Ez (%Z)</span>}</span></tt>\n\n<tt><small>{calendar}</small></tt>";

          calendar = {
            mode = "year";
            mode-mon-col = 3;
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#a6e3a1'><b>{}</b></span>";
              days = "<span color='#7f849c'><b>{}</b></span>";
              weekdays = "<span color='#fab387'><b>{}</b></span>";
              today = "<span color='#f9e2af'><b>{}</b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-click = "tz_up";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        cpu = {
          format = " {:.1f}%";
        };
        "custom/gpu" = {
          exec = "${lib.getExe' osConfig.hardware.nvidia.package "nvidia-smi"} --query-gpu=utilization.gpu --format=csv,noheader,nounits";
          format = "󰾲  {}%";
          interval = 10;
          return-type = "";
        };
        memory = {
          format = " {percentage}%";
          format-alt = " {used}/{total} GiB";
        };
        "custom/wlogout" = {
          format = "";
          interval = "once";
          on-click = "${lib.getExe pkgs.wlogout} -p layer-shell";
        };
      }
    ];
  };
}
