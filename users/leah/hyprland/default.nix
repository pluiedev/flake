{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./mako.nix
    ./waybar
  ];

  roles.hyprland.enable = true;

  hm = {
    home.packages = with pkgs; [
      hyprpicker
      font-awesome
      networkmanagerapplet # necessary for icons
    ];

    programs = {
      kitty.enable = true;

      wpaperd.enable = true;

      fuzzel = {
        enable = true;
        settings.main = {
          font = "Iosevka Nerd Font:size=13";
          dpi-aware = true;
        };
      };
    };

    services.cliphist.enable = true;

    wayland.windowManager.hyprland.settings = let
      inherit (lib) getExe getExe' flatten mod range pipe;
    in
      with pkgs; {
        "$mod" = "SUPER";
        "$grimblast" = getExe grimblast;
        "$pamixer" = getExe pamixer;
        "$brightnessctl" = getExe brightnessctl;
        "$wl-paste" = getExe' wl-clipboard "wl-paste";

        monitor = ",2560x1600@165,0x0,1.25";

        env = [
          "WLR_DRM_DEVICES,/dev/dri/card0" # use iGPU
          "GRIMBLAST_EDITOR,${lib.getExe pkgs.swappy} -f"
        ];

        exec-once = [
          "${getExe waybar}"
          "${polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"

          "$wl-paste --type  text --watch ${getExe cliphist} store"
          "$wl-paste --type image --watch ${getExe cliphist} store"

          "[workspace 1] ${getExe firefox}"

          # FIXME: GTK 3 crashes with wayland IM module enabled right now.
          # Somehow using native wayland doesn't fix this, gonna do this for now
          "[workspace 1 silent; float] GTK_IM_MODULE= ${getExe _1password-gui}"
          "[workspace 2] ${getExe' neovide "neovide"}"
          "[workspace 2] ${getExe kitty}"
        ];

        windowrulev2 = [
          "float,class:(org.kde.polkit-kde-authentication-agent-1)"
          "float,class:(firefox),title:(Picture-in-Picture)"
        ];

        workspace = [
          "1,default:true"
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

            # Screenshotting
            "CTRL_R, Delete, exec, $grimblast edit area"
            "SHIFT_R, Delete, exec, $grimblast edit active"
            "CTRL_R SHIFT_R, Delete, exec, $grimblast edit output"
            ", Print, exec, $grimblast edit area"
            "SHIFT, Print, exec, $grimblast edit active"
            "CTRL SHIFT, Print, exec, $grimblast edit output"

            # Because of how cursed ASUS's laptop keyboard works
            # (Fn+F6 produces a sequence of keystrokes that correspond to Windows+Shift+S on Windows),
            # I need to do this to make it do what it's intended to do
            "SUPER SHIFT, S, exec, $grimblast edit area"
            "CTRL SUPER SHIFT, S, exec, $grimblast edit output"
            "ALT SUPER SHIFT, S, exec, $grimblast edit active"

            ", XF86AudioMute, exec, $pamixer -t"
            ", XF86AudioMicMute, exec, $pamixer --default-source -t"

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
            (map (i: let
              key = mod i 10;
            in [
              "$mod, ${toString key}, workspace, ${toString i}"
              "$mod SHIFT, ${toString key}, movetoworkspace, ${toString i}"
            ]))
            flatten
          ];

        # Press Super once to open Fuzzel; twice to close it
        bindr = [
          "$mod, Super_L, exec, pkill fuzzel || ${getExe fuzzel}"
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

        bindm = [
          # Move/resize windows with mod + LMB/RMB and dragging
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      };
  };
}
