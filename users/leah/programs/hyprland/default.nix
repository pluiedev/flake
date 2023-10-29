{
  pkgs,
  lib,
  user,
  config,
  osConfig,
  ...
}: {
  imports = [
    ./fuzzel.nix
    ./kitty.nix
    ./mako.nix
    ./theming.nix
    ./waybar
  ];

  home.packages = with pkgs; [
    hyprpicker
    swaybg
    font-awesome
    networkmanagerapplet # necessary for icons
    qt5.qtwayland
    dolphin
    breeze-icons
  ];

  services.cliphist.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    enableNvidiaPatches = true;

    settings = let
      inherit (lib) getExe getExe';
    in
      with pkgs; {
        "$mod" = "SUPER";
        "$grimblast" = getExe grimblast;
        "$inotifywait" = getExe' inotify-tools "inotifywait";
        "$pamixer" = getExe pamixer;
        "$brightnessctl" = getExe brightnessctl;
        "$wl-paste" = getExe' wl-clipboard "wl-paste";

        monitor = ",2560x1600@165,0x0,1.25";

        env = [
          "XCURSOR_SIZE,24"
          "WLR_DRM_DEVICES,/dev/dri/card0" # Use iGPU

          # Fcitx5
          "GTK_IM_MODULE,wayland"
          "QT_IM_MODULE,fcitx"
          "XMODIFIERS,@im=fcitx"
          "INPUT_METHOD,fcitx"
          "SDL_IM_MODULE,fcitx"
          "GLFW_IM_MODULE,ibus"
          "GRIMBLAST_EDITOR,${getExe swappy} -f"
        ];

        exec-once =
          [
            ''${getExe bash} -c "while true; do (${getExe waybar} &); $inotifywait -e create,modify ${user.homeDirectory}/.config/waybar/*; pkill waybar; done"''
            "${polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"

            "$wl-paste  --type text --watch ${getExe cliphist} store"
            "$wl-paste --type image --watch ${getExe cliphist} store"
          ]
          ++ lib.optional osConfig.hardware.bluetooth.enable
          (getExe' blueman "blueman-applet")
          ++ lib.optional config.pluie.user.desktop._1password.autostart
          "[workspace 2 silent] ${getExe osConfig.programs._1password-gui.package} --enable-features=UseOzonePlatform --ozone-platform-hint=wayland"
          ++ lib.optional osConfig.networking.networkmanager.enable
          (getExe networkmanagerapplet)
          ++ lib.optional (config.pluie.user.ime.enabled == "fcitx5")
          "${getExe' fcitx5 "fcitx5"} -d --replace &";

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
          "col.active_border" = "rgba(f5e0dcee) rgba(f38ba8ee) 45deg";
          "col.inactive_border" = "rgba(11111baa)";
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
          "col.shadow" = "rgba(11111bee)";
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

        gestures = {
          workspace_swipe = true;
        };

        xwayland = {
          # some XWayland apps, like say, 1Password, look absolutely horrendous without this on.
          force_zero_scaling = true;
        };

        misc = {
          # I don't like fun
          disable_hyprland_logo = true;
        };

        bind =
          [
            "$mod, Q, killactive,"
            "$mod, T, exec, ${getExe kitty}"
            "$mod ALT, Q, exit,"
            "$mod, E, exec, ${getExe' dolphin "dolphin"}" # TODO: annoy maintainers to add meta.mainProgram
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
          lib.flatten (builtins.map (i: let
            key = lib.mod i 10;
          in [
            "$mod, ${toString key}, workspace, ${toString i}"
            "$mod SHIFT, ${toString key}, movetoworkspace, ${toString i}"
          ]) (lib.range 1 10));

        # Press Super once to open Fuzzel; twice to close it
        bindr = [
          "$mod, Super_L, exec, pkill fuzzel || ${getExe fuzzel}"
        ];

        # Media keys
        binde = [
          ", XF86AudioLowerVolume, exec, $pamixer -d 5"
          ", XF86AudioRaiseVolume, exec, $pamixer -i 5"
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
