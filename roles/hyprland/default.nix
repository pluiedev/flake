{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.roles.hyprland = {
    enable = mkEnableOption "Hyprland";
  };
}
