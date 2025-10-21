{
  pkgs,
  lib,
  ...
}:
let
  common = {
    layer = "top";
    reload_style_on_change = true;
  };

  interval = 5;
  restart-interval = 20;

  poll-intel-gpu = pkgs.writeShellApplication {
    name = "poll-intel-gpu";
    runtimeInputs = with pkgs; [
      intel-gpu-tools
      jq
    ];

    text = ''
      poll_rate=$1
      intel_gpu_top -J -s "$poll_rate" | jq -c --unbuffered --stream '
        fromstream(2|truncate_stream(inputs))
          | select(has("Render/3D"))
          | {
            percentage: ."Render/3D".busy,
            tooltip: "Render 3D: \(."Render/3D".busy | round)%\nBlitter: \(.Blitter.busy | round)%\nVideo: \(.Video.busy | round)%\nVideo Enhance: \(.VideoEnhance.busy | round)%\nCompute: \(.Compute.busy | round)%",
          }'
    '';
  };
in
map (v: common // v) [
  {
    name = "top";
    position = "top";

    modules-left = [ "group/dials" ];
    modules-center = [ "clock" ];
    modules-right = [
      "group/apps"
      "privacy"
      "group/appearance"
      "group/connectivity"
      "group/power"
    ];

    "group/apps" = {
      orientation = "inherit";
      modules = [
        "custom/notification"
        "tray"
      ];
      drawer = { };
    };
    "group/dials" = {
      orientation = "inherit";
      modules = [
        "cpu"
        "custom/gpu-nvidia"
        "custom/gpu-intel"
        "memory"
      ];
    };
    "group/appearance" = {
      orientation = "inherit";
      modules = [
        "pulseaudio"
        "backlight"
      ];
      drawer = { };
    };
    "group/connectivity" = {
      orientation = "inherit";
      modules = [
        "network"
        "bluetooth"
      ];
      drawer = { };
    };
    "group/power" = {
      orientation = "inherit";
      modules = [
        "battery"
        "custom/wleave"
      ];
      drawer = { };
    };

    # Modules
    tray = {
      icon-size = 24;
      spacing = 6;
    };
    cpu = {
      format = " {usage}%";
      inherit interval;
    };
    memory = {
      format = " {percentage}%";
      inherit interval;
    };
    network = {
      format-wifi = "";
      format-ethernet = "";
      format-disconnected = "";
      tooltip-format-wifi = "{essid} ({signalStrength}%)";
    };
    pulseaudio.format = " {volume}%";
    backlight.format = " {percent}%";
    clock = {
      format = "<b>{0:%H:%M}</b> <span size='small' color='#a6adc8'>{0:L%e %b '%y / %a (%Ez %Z)}</span>";
      locale = "de_DE.UTF-8";
      tooltip-format = "{tz_list}";
      timezones = [
        "Europe/Berlin"
        "Asia/Shanghai"
      ];
      actions = {
        on-scroll-up = "tz_up";
        on-scroll-down = "tz_down";
        on-click = "tz_up";
        on-click-right = "tz_down";
      };
    };
    bluetooth = {
      format-off = " ";
      format-on = " ";
      format-connected = " {device_alias}";
      format-connected-battery = " {device_alias} {device_battery_percentage}%";
    };
    battery = {
      inherit interval;
      states = {
        full = 100;
        not-quite-full = 65;
        warning = 25;
        critical = 10;
      };
      format = "{icon} {capacity}%";
      format-plugged = " {capacity}%";
      format-charging = " {capacity}%";
      format-critical = "󰂃 {capacity}%";
      format-icons = [
        ""
        ""
        ""
        ""
        ""
      ];
    };

    # Custom modules
    "custom/gpu-nvidia" = {
      exec = "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits";
      exec-if = "command -v nvidia-smi";
      format = " {}%";
      inherit interval restart-interval;
    };
    "custom/gpu-intel" = {
      exec = "${lib.getExe poll-intel-gpu} ${toString (interval * 1000)}";
      exec-if = "command -v intel_gpu_top";
      format = " {percentage}%";
      return-type = "json";
      # interval mustn't be set here as the script is continuous
      inherit restart-interval;
    };
    "custom/notification" = {
      tooltip = false;
      format = "{icon} {text}";
      format-icons = {
        notification = "";
        none = "";
        dnd-notification = "";
        dnd-none = "";
        inhibited-notification = "";
        inhibited-none = "";
        dnd-inhibited-notification = "";
        dnd-inhibited-none = "";
      };
      return-type = "json";
      exec = "swaync-client -swb";
      exec-if = "command -v swaync-client";
      on-click = "swaync-client -t -sw";
      on-click-right = "swaync-client -d -sw";
      escape = true;
    };
    "custom/wleave" = {
      format = "";
      on-click = "wleave -x";
    };
  }
  {
    name = "dock";
    position = "bottom";

    modules-center = [ "wlr/taskbar" ];

    "wlr/taskbar" = {
      icon-size = 64;
      on-click = "activate";
    };
  }
  {
    name = "workspaces";
    position = "left";
    exclusive = false;

    modules-center = [ "niri/workspaces" ];

    "niri/workspaces" = {
      format = "{icon}";
      format-icons = {
        chat = "";
        dev = "";
        gaming = "";
        default = "•";
      };
    };
  }
]
