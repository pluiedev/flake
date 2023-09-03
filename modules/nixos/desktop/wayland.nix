{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.pluie.desktop.wayland;
  inherit (lib) mkEnableOption mkIf;
in {
  options.pluie.desktop.wayland.enable = mkEnableOption "Wayland";

  config = mkIf cfg.enable {
    programs.xwayland.enable = true;

    environment.systemPackages = [pkgs.wl-clipboard];

    # Force Chromium & most Electron apps to run natively on Wayland.
    # For some reason, Xwayland didn't even work for me (Electron apps would
    # have a completely black screen) so this is, in fact, mandatory.
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
