{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ext.programs.moor;

  toFlag =
    k: v:
    if lib.isBool v then
      lib.optionalString (v) "-${k}"
    else if lib.isString v then
      "-${k}=${v}"
    else
      throw "Unsupported type";

in
{
  options.ext.programs.moor = {
    enable = lib.mkEnableOption "Moor";

    package = lib.mkPackageOption pkgs "moor" { };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType =
          with lib.types;
          attrsOf (oneOf [
            str
            bool
          ]);
      };
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [ cfg.package ];
    environment.sessionVariables = {
      PAGER = "moor";
      moor = lib.concatStringsSep " " (lib.mapAttrsToList toFlag cfg.settings);
    };
  };
}
