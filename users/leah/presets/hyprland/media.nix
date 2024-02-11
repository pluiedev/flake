{
  config,
  lib,
  pkgs,
  ...
}: {
  hm.services = {
    mpris-proxy.enable = true;
    mpd = {
      enable = true;
      musicDirectory = "${config.hm.home.homeDirectory}/music";
    };
    mpd-mpris.enable = true;
  };

  hm.wayland.windowManager.hyprland.settings = {
    "$pamixer" = lib.getExe pkgs.pamixer;
    "$brightnessctl" = lib.getExe pkgs.brightnessctl;

    bind = [
      ", XF86AudioMute, exec, $pamixer -t"
      ", XF86AudioMicMute, exec, $pamixer --default-source -t"
    ];

    # Media keys
    binde = [
      ", XF86AudioLowerVolume, exec, $pamixer -ud 5"
      ", XF86AudioRaiseVolume, exec, $pamixer -ui 5"
      ", XF86MonBrightnessDown, exec, $brightnessctl --device=intel_backlight set 5%-"
      ", XF86MonBrightnessUp, exec, $brightnessctl --device=intel_backlight set +5%"
      ", XF86KbdBrightnessDown, exec, $brightnessctl --device=asus::kbd_backlight set 1-"
      ", XF86KbdBrightnessUp, exec, $brightnessctl --device=asus::kbd_backlight set +1"
    ];
  };
}
