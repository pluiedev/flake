{pkgs, ...}: {
  users.groups.input = {};
  roles.base.user.extraGroups = ["input"];
  hm.services.fusuma = {
    enable = true;
    extraPackages = with pkgs; [xdotool wmctrl coreutils];
    settings.swipe."3" = {
      left = {
        workspace = "next"; # Switch to next workspace
        keypress = {
          LEFTSHIFT.window = "next"; # Move window to next workspace
          LEFTMETA.command = "xdotool key --clearmodifiers super+ctrl+Left"; # Move window to left side
        };
      };
      right = {
        workspace = "prev"; # Switch to previous workspace
        keypress = {
          LEFTSHIFT.window = "prev"; # Move window to previous workspace
          LEFTMETA.command = "xdotool key --clearmodifiers super+ctrl+Right"; # Move window to right side
        };
      };
      up = {
        command = "xdotool key Control_L+F10"; # Workspace overview
        keypress.LEFTMETA.window.maximized = "toggle"; # Toggle Maximize/Unmaximize Window
      };
      down = {
        command = "xdotool key Control_L+F12"; # Workspace overview
        keypress.LEFTMETA.window = "close"; # Toggle Maximize/Unmaximize Window
      };
    };
  };
}
