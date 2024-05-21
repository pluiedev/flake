{ lib, ... }:
let
  inherit (lib)
    mkAliasOptionModule
    mkEnableOption
    mkOption
    types
    ;
in
{
  imports = [
    (mkAliasOptionModule
      [
        "roles"
        "qt"
        "platform"
      ]
      [
        "qt"
        "platformTheme"
      ]
    )
  ];

  options.roles.qt = {
    enable = mkEnableOption "Qt" // {
      default = true;
    };

    qt5ct.settings = mkOption {
      type = types.nullOr (types.attrsOf types.anything);
      default = null;
    };
    qt6ct.settings = mkOption {
      type = types.nullOr (types.attrsOf types.anything);
      default = null;
    };
  };
}
