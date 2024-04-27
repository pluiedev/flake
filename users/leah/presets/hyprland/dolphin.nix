{
  pkgs,
  lib,
  ...
}: {
  hm.home.packages = [pkgs.dolphin];

  # TODO: annoy maintainers to add meta.mainProgram
  roles.hyprland.settings.bind = ["$mod, E, exec, ${lib.getExe' pkgs.dolphin "dolphin"}"];

  # Required for detecting storage devices
  services.udisks2.enable = true;
}
