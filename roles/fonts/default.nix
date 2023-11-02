{lib, ...}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.roles.fonts = {
    enable = mkEnableOption "default fonts";
    packages = mkOption {
      type = types.listOf types.package;
      default = [];
    };
    defaults = mkOption {
      type = types.attrsOf (types.listOf types.str);
      default = {};
    };
  };
}
