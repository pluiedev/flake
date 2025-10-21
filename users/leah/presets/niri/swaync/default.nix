{
  pkgs,
  ...
}:
{
  hjem.users.leah = {
    packages = [ pkgs.swaynotificationcenter ];
    systemd.targets.graphical-session-pre.wants = [ "swaync.service" ];

    xdg.config.files = {
      "swaync/style.css".source = ./style.css;
      "swaync/config.json".source = ./config.json;
    };
  };
}
