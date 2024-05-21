{ lib, pkgs, ... }:
{
  hm.wayland.windowManager.hyprland.settings =
    let
      inherit (lib)
        getExe
        flatten
        mod
        range
        pipe
        ;
    in
    with pkgs;
    {
      "$mod" = "SUPER";

      monitor = "eDP-1,2560x1600@165,0x0,1.25";

      env = [
        "WLR_DRM_DEVICES,/dev/dri/card0" # use iGPU
      ];

      exec-once = [
        (getExe config.hm.programs.wpaperd.package)
        (getExe config.hm.programs.waybar.package)
        "${polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"

        # FIXME: GTK 3 crashes with wayland IM module enabled right now.
        # Somehow using native wayland doesn't fix this, gonna do this for now
        # FIXME: Running without --disable-gpu results in a blank screen (see nixpkgs#278040)
        "[workspace 1 silent; float] GTK_IM_MODULE= ${getExe _1password-gui} --disable-gpu"
      ];

      windowrulev2 = [
        "float,class:(org.kde.polkit-kde-authentication-agent-1)"
        "float,class:(firefox),title:(Picture-in-Picture)"
      ];

      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "compose:ralt";
        kb_rules = "";

        follow_mouse = true;

        touchpad = {
          natural_scroll = true;
          clickfinger_behavior = true;
          middle_button_emulation = true;
          drag_lock = true;
        };

        sensitivity = 0;
      };

      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 2;
        "col.active_border" = "rgba($rosewaterAlphaee) rgba($redAlphaee) 45deg";
        "col.inactive_border" = "rgba($crustAlphaaa)";
        resize_on_border = true;
        layout = "dwindle";
      };

      decoration = {
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };

        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba($crustAlphaee)";
      };

      animations = {
        enabled = true;

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      gestures.workspace_swipe = true;

      # some XWayland apps, like say, 1Password, look absolutely horrendous without this on.
      xwayland.force_zero_scaling = true;

      # I don't like fun
      misc.disable_hyprland_logo = true;

      bind =
        [
          "$mod, Q, killactive,"
          "$mod, T, exec, ${getExe kitty}"
          "$mod ALT, Q, exit,"
          "$mod, V, togglefloating,"
          "$mod, P, pseudo,"
          "$mod, J, togglesplit,"

          # Move focus with mod + arrow keys
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          # Scroll through existing workspaces with mod + scroll
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"
        ]
        ++
        # Switch workspaces with mod + [0-9]
        # Move active window to a workspace with mod + SHIFT + [0-9]
        pipe (range 1 10) [
          (map (
            i:
            let
              key = mod i 10;
            in
            [
              "$mod, ${toString key}, workspace, ${toString i}"
              "$mod SHIFT, ${toString key}, movetoworkspace, ${toString i}"
            ]
          ))
          flatten
        ];

      # Press Super once to open Fuzzel; twice to close it
      bindr = [ "$mod, Super_L, exec, pkill fuzzel || ${getExe fuzzel}" ];

      bindm = [
        # Move/resize windows with mod + LMB/RMB and dragging
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
}
