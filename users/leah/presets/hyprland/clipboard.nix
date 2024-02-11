{
  pkgs,
  lib,
  ...
}: {
  hm.services.cliphist.enable = true;

  hm.wayland.windowManager.hyprland.settings = {
    exec-once = let
      wl-paste = lib.getExe' pkgs.wl-clipboard "wl-paste";
      cliphist = lib.getExe pkgs.cliphist;
    in [
      "${wl-paste} --type  text --watch ${cliphist} store"
      "${wl-paste} --type image --watch ${cliphist} store"
    ];
  };
}
