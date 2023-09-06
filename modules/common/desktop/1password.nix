{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption;
  cfg = config.pluie.desktop._1password;
in {
  options.pluie.desktop._1password.enable = mkEnableOption "1Password";
}
