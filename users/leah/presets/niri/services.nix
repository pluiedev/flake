{
  config,
  pkgs,
  lib,
  ...
}:
let
  swaybg' = pkgs.writeShellApplication {
    name = "swaybg";
    runtimeInputs = [ pkgs.swaybg ];
    text = ''
      swaybg -i ${../../wallpaper.jpg}
    '';
  };

  swayidle' = pkgs.writeShellApplication {
    name = "swayidle";

    runtimeInputs = [
      pkgs.swayidle
      config.hjem.users.leah.ext.programs.swaylock.finalPackage
      pkgs.niri
    ];

    text = ''
      exec swayidle -w \
        timeout 180 swaylock \
        timeout 360 'niri msg action power-off-monitors' \
          resume 'niri msg action power-on-monitors' \
        before-sleep swaylock \
        lock swaylock \
        unlock "pkill -SIGUSR1 swaylock" \
        "$@"
    '';
  };
in
{
  hjem.users.leah.packages = [
    swayidle'
    swaybg'
  ];

  security = {
    polkit.enable = true;
    soteria.enable = true;
  };

  # Needed by the Waybar config
  services.power-profiles-daemon.enable = true;

  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = ../../wallpaper.jpg;
        fit = "Cover";
      };
      GTK.application_prefer_dark_theme = true;
    };
    cursorTheme.name = "BreezeX-Black";
    font = {
      name = "DM Sans";
      size = 14;
    };
  };

  # Niri installs XDP GNOME by default but not XDP GTK,
  # which is required for certain functionality such as opening files
  xdg.portal = {
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
