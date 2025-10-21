{
  lib,
  config,
  ...
}:
let
  swayosd = config.hjem.users.leah.ext.programs.swayosd.package;
in
{
  # LibInput backend
  services = {
    dbus.packages = [ swayosd ];
    udev.packages = [ swayosd ];
  };
  systemd = {
    packages = [ swayosd ];
    targets.graphical.wants = [ "swayosd-libinput-backend.service" ];
  };

  # Server
  hjem.users.leah = {
    ext.programs.swayosd = {
      enable = true;
      settings.server.show_percentage = true;
      style = ./style.css;
    };
    systemd.services.swayosd-server = {
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig.ExecStart = lib.getExe' swayosd "swayosd-server";
      restartTriggers = [ swayosd ];
    };
  };
}
