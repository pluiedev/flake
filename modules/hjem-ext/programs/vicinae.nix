{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ext.programs.vicinae;
  format = pkgs.formats.json { };
in
{
  options.ext.programs.vicinae = {
    enable = lib.mkEnableOption "Vicinae";
    package = lib.mkPackageOption pkgs "vicinae" { };

    settings = lib.mkOption {
      inherit (format) type;
      description = ''
        Configuration written to {file}`$XDG_CONFIG_HOME/vicinae/vicinae.json`.
      '';
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [ cfg.package ];
    xdg.config.files."vicinae/vicinae.json" = {
      generator = format.generate "vicinae.json";
      value = cfg.settings;
    };
  };
}
