{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.roles.bluetooth.enable = mkEnableOption "Bluetooth";
}
