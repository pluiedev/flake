{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ext.programs.vesktop;
  format = pkgs.formats.json { };
in
{
  options.ext.programs.vesktop = {
    enable = lib.mkEnableOption "Vesktop";

    package = lib.mkPackageOption pkgs "vesktop" { };

    settings = lib.mkOption {
      inherit (format) type;
      description = ''
        Configuration written to {file}`$XDG_CONFIG_HOME/vesktop/settings.json`.
      '';
      default = { };
    };

    vencord = {
      enable = lib.mkEnableOption "Vencord";

      useSystemPackage = lib.mkOption {
        type = lib.types.bool;
        description = "Use the Vencord package in Nixpkgs, instead of allowing Vesktop to manage its own Vencord install";
        default = false;
      };

      settings = lib.mkOption {
        inherit (format) type;
        description = ''
          Configuration of the bundled client mod, Vencord, written to {file}`$XDG_CONFIG_HOME/vesktop/settings/settings.json`.
        '';
        default = { };
      };

      css = lib.mkOption {
        type = lib.types.lines;
        description = ''
          Style sheet of the bundled client mod, Vencord, written to {file}`$XDG_CONFIG_HOME/vesktop/settings/quickCss.css`.
        '';
        default = "";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [
      (cfg.package.override {
        withSystemVencord = cfg.vencord.useSystemPackage;
      })
    ];

    files =
      {
        ".config/vesktop/settings.json".source = format.generate "vesktop-settings.json" cfg.settings;
      }
      // lib.optionalAttrs cfg.vencord.enable {
        ".config/vesktop/settings/settings.json".source =
          format.generate "vencord-settings.json" cfg.vencord.settings;

        ".config/vesktop/settings/quickCss.css".text = cfg.vencord.css;
      };
  };
}
