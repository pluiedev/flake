{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.roles._1password;
in {
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      _1password
      _1password-gui
    ];
  };
}
