{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.nekoray;
  format = pkgs.formats.json { };

  profileSubmodule = lib.types.submodule {
    freeformType = format.type;

    type = lib.mkOption {
      type = lib.types.enum [ "hysteria2" ];
    };

    bean = {
      addr = lib.mkOption { type = lib.types.str; };
    };
  };
in
{
  services.nekoray = {
    enable = lib.mkEnableOption "Nekoray";

    profiles = lib.mkOption {
      type = lib.listOf profileSubmodule;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.nekoray ];

    xdg.configFile = lib.imap0 (
      i: v:
      lib.nameValuePair "nekoray/config/profiles/${toString i}.json" {
        source = format.generate "nekoray-profile-${toString i}.json" v;
      }
    );
  };
}
