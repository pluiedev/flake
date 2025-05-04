{
  pkgs,
  ...
}:
{
  hjem.users.leah = {
    packages = [ pkgs.waybar ];

    files.".config/waybar/style.css".source = ./style.css;
    files.".config/waybar/config.jsonc".source = ./config.jsonc;
  };
}
