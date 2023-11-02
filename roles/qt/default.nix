{lib, ...}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.roles.qt = {
    enable = mkEnableOption "Qt" // {default = true;};

    theme = mkOption {
      type = types.nullOr types.path;
      default = null;
    };
  };
}
