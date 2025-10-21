{
  pkgs,
  ...
}@args:
let
  jsonFormat = pkgs.formats.json { };
  config = import ./config.nix args;
in
{
  hjem.users.leah = {
    packages = [ pkgs.waybar ];

    xdg.config.files = {
      "waybar/style.css".source = ./style.css;
      "waybar/config.jsonc".source = jsonFormat.generate "waybar-config.jsonc" config;
    };
  };
}
