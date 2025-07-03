{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.ext.programs.git;
  format = pkgs.formats.gitIni { };
in
{
  options.ext.programs.git = {
    enable = lib.mkEnableOption "Git";
    package = lib.mkPackageOption pkgs "git" { };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;
      };
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [ cfg.package ];
    files.".config/git/config".source = lib.mkIf (cfg.settings != { }) (
      format.generate "git-config" cfg.settings
    );
  };
}
