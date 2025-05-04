{
  config,
  pkgs,
  lib,
  ...
}:
let
  mkStartupService = run: {
    enable = true;
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = run;
      Restart = "on-failure";
    };
  };

  swaylock-config = {
    screenshots = true;
    scaling = "fit";
    clock = true;
    indicator-idle-visible = true;
    grace = 3;
    effect-blur = "10x10";
    effect-vignette = "0.5:0.8";
    effect-pixelate = 4;

    text-color = "#cdd6f4";
    inside-color = "#181825";
    inside-clear-color = "#a6e3a1";
    inside-ver-color = "#cba6f7";
    inside-wrong-color = "#f38ba8";
    ring-color = "#1e1e2e";
    ring-clear-color = "#a6e3a1";
    ring-ver-color = "#cba6f7";
    ring-wrong-color = "#f38ba8";
    key-hl-color = "#eba0ac";
    bs-hl-color = "#6c7086";
    line-color = "#313244";

    timestr = "%H:%M";
    datestr = "%e %b '%y / %a";
  };

  swaylock' = pkgs.writeShellScript "swaylock-wrapped" ''
    ${lib.getExe pkgs.swaylock} -f ${lib.cli.toGNUCommandLineShell { } swaylock-config}
  '';

  swayidle' = pkgs.writeShellScript "swayidle-wrapped" ''
    ${lib.getExe pkgs.swayidle} -w \
      timeout 300 ${swaylock'} \
      timeout 600 'niri msg action power-off-monitors' \
        resume 'niri msg action power-on-monitors' \
      before-sleep ${swaylock'} \
      lock ${swaylock'} \
      unlock 'pkill -SIGUSR1 -ux $USER ${swaylock'}'
  '';
in
{
  systemd.packages = with pkgs; [
    waybar
    swaynotificationcenter
    xwayland-satellite
  ];

  systemd.user.services = {
    polkit-gnome-authentication-agent-1 = mkStartupService "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";

    swaybg = mkStartupService "${lib.getExe pkgs.swaybg} -i ${../../wallpaper.jpg}";

    fcitx5 = lib.mkIf (config.i18n.inputMethod.type == "fcitx5") (
      mkStartupService (lib.getExe config.i18n.inputMethod.package)
    );

    swayidle = mkStartupService swayidle';
  };

  security.polkit.enable = true;

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
