{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption;
in {
  options.pluie.desktop.fonts.enable = mkEnableOption "default fonts";
}
