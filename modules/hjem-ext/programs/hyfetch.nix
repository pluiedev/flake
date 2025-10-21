{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.ext.programs.hyfetch;
  format = pkgs.formats.json { };
  configFile = format.generate "hyfetch.json" cfg.settings;
in
{
  options.ext.programs.hyfetch = {
    enable = lib.mkEnableOption "Hyfetch";
    package = lib.mkPackageOption pkgs "hyfetch" { };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;

        options = {
          backend = lib.mkOption {
            type = lib.types.enum [
              "neofetch"
              "fastfetch"
              "qwqfetch"
            ];
          };
        };
      };
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    packages =
      [ cfg.package ]
      ++ lib.optional (cfg.settings.backend == "fastfetch") pkgs.fastfetch
      ++ lib.optional (cfg.settings.backend == "neofetch") pkgs.neofetch;
    # TODO: add qwqfetch when it's added to nixpkgs

    xdg.config.files."hyfetch.json".source = lib.mkIf (cfg.settings != { }) configFile;
  };
}
