{
  config,
  lib,
  pkgs,
  inputs',
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    mkIf
    ;
  cfg = config.programs.ghostty;
  format = pkgs.formats.keyValue {
    listsAsDuplicateKeys = true;
  };
in
{
  options.programs.ghostty = {
    enable = mkEnableOption "Ghostty";

    package = (mkPackageOption pkgs "Ghostty" {}) // {
      inherit (inputs'.ghostty.packages) default;
    };

    settings = mkOption {
      inherit (format) type;
      description = ''
        Configuration written to {file}`$XDG_CONFIG_HOME/ghostty/config`.
      '';
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."ghostty/config".source = format.generate "ghostty-config" cfg.settings;
  };
}
