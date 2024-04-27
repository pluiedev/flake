{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkOption mkIf types;
  cfg = config.programs.vesktop;
  format = pkgs.formats.json {};
in {
  options.programs.vesktop = {
    enable = mkEnableOption "Vesktop";

    package = mkPackageOption pkgs "Vesktop" {
      default = ["vesktop"];
    };

    settings = mkOption {
      inherit (format) type;
      description = ''
        Configuration written to {file}`$XDG_CONFIG_HOME/vesktop/settings.json`.
      '';
      default = {};
    };

    vencord = {
      useSystemPackage = mkOption {
        type = types.bool;
        description = "Use the Vencord package in Nixpkgs, instead of allowing Vesktop to manage its own Vencord install";
        default = true;
      };

      settings = mkOption {
        inherit (format) type;
        description = ''
          Configuration of the bundled client mod, Vencord, written to {file}`$XDG_CONFIG_HOME/vesktop/settings/settings.json`.
        '';
        default = {};
      };

      css = mkOption {
        type = types.lines;
        description = ''
          Style sheet of the bundled client mod, Vencord, written to {file}`$XDG_CONFIG_HOME/vesktop/settings/quickCss.css`.
        '';
        default = "";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      (cfg.package.override {withSystemVencord = cfg.vencord.useSystemPackage;})
    ];

    xdg.configFile = {
      "vesktop/settings.json".source = format.generate "vesktop-settings.json" cfg.settings;

      "vesktop/settings/settings.json".source = format.generate "vencord-settings.json" cfg.vencord.settings;
      "vesktop/settings/quickCss.css".text = cfg.vencord.css;
    };
  };
}
