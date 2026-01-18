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
      exec swaybg -i "${../../wallpaper.jpg}" "$@"
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

  hjem.users.leah.systemd.services = {
    swaybg = {
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig.ExecStart = lib.getExe swaybg';
      restartTriggers = [ swaybg' ];
    };
    swayidle = {
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig.ExecStart = lib.getExe swayidle';
      restartTriggers = [ swayidle' ];
    };
  };

  security = {
    polkit.enable = true;
    soteria.enable = true;
  };

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
      name = "Manrope V5";
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
