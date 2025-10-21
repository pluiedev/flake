{
  pkgs,
  ...
}@args:
let
  jsonFormat = pkgs.formats.json { };
  config = import ./config.nix args;
  configFile = jsonFormat.generate "waybar-config.jsonc" config;
in
{
  hjem.users.leah = {
    packages = [ pkgs.waybar ];
    systemd.targets.graphical-session.wants = [ "waybar.service" ];

    xdg.config.files = {
      "waybar/style.css".source = ./style.css;
      "waybar/config.jsonc".source = configFile;
    };
  };
}
