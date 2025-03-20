{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.moar;

  toFlag = k: v: if lib.isBool v then
    lib.optionalString (v) "-${k}"
  else if lib.isString v then
    "-${k}=${v}"
  else
    throw "Unsupported type";
    
in
{
  options.programs.moar = {
    enable = lib.mkEnableOption "Moar";

    package = lib.mkPackageOption pkgs "moar" {};

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = with lib.types; attrsOf (oneOf [
          str
          bool
        ]);
      };
      default = {};
    };
  };

  config = lib.mkIf (cfg.enable) {
    home.sessionVariables = {
      PAGER = "moar";
      MOAR = lib.concatStringsSep " " (lib.mapAttrsToList toFlag cfg.settings);
    };
  };
}
