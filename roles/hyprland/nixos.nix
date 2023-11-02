{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkAliasOptionModule;
  cfg = config.roles.hyprland;
in {
  imports = [
    (mkAliasOptionModule ["roles" "hyprland" "settings"] ["hm" "wayland" "windowManager" "hyprland" "settings"])
  ];

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      enableNvidiaPatches = true;
    };

    hm.wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      enableNvidiaPatches = true;
    };

    hm.home.packages = [pkgs.wl-clipboard];
  };
}
