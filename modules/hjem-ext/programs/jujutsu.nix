{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.ext.programs.jujutsu;
  format = pkgs.formats.toml { };
in
{
  options.ext.programs.jujutsu = {
    enable = lib.mkEnableOption "Jujutsu";
    package = lib.mkPackageOption pkgs "jujutsu" { };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;
      };
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [ cfg.package ];
    files.".config/jj/config.toml".source = lib.mkIf (cfg.settings != { })
      (format.generate "jj-config.toml" cfg.settings);
  };
}
