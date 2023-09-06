{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.pluie.desktop._1password;
in {
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      _1password
      _1password-gui
    ];
  };
}
