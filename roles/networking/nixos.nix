{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf getExe;
  cfg = config.roles.networking;
in
{
  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
    roles.base.user.extraGroups = mkIf config.roles.base.canSudo [ "networkmanager" ];

    hm.home.packages = [ pkgs.networkmanagerapplet ];
    roles.hyprland.settings.exec-once = [ (getExe pkgs.networkmanagerapplet) ];
  };
}
