{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ext.programs.swayosd;
  format = pkgs.formats.toml { };
in
{
  options.ext.programs.swayosd = {
    enable = lib.mkEnableOption "SwayOSD";

    package = lib.mkPackageOption pkgs "swayosd" { };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;
      };
      default = { };
    };

    style = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [ cfg.package ];

    files.".config/swayosd/config.toml".source = lib.mkIf (cfg.settings != { }) (
      format.generate "swayosd-config.toml" cfg.settings
    );
    files.".config/swayosd/style.css".source = lib.mkIf (cfg.style != null) cfg.style;
  };
}
