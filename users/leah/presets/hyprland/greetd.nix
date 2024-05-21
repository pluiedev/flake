{ lib, pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${lib.getExe pkgs.greetd.tuigreet} --time --user-menu -r --remember-user-session -g 'Welcome back! <3' --asterisks --cmd ${lib.getExe pkgs.hyprland}";
      user = "greeter";
    };
  };
  # Stop the damn TUI from bleeding
  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  # https://github.com/apognu/tuigreet/issues/68#issuecomment-1586359960
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
