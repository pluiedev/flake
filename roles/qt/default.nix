{lib, ...}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.roles.qt = {
    enable = mkEnableOption "Qt" // {default = true;};

    qt5.settings = mkOption {
      type = types.nullOr (types.attrsOf types.anything);
      default = null;
    };
    qt6.settings = mkOption {
      type = types.nullOr (types.attrsOf types.anything);
      default = null;
    };
  };
}
