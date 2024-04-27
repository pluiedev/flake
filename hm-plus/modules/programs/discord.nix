{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkOption mkIf optionalAttrs types;
  cfg = config.programs.discord;
  format = pkgs.formats.json {};
in {
  options.programs.discord = {
    enable = mkEnableOption "Discord";

    package = mkPackageOption pkgs "Discord" {
      default = ["discord"];
    };

    settings = mkOption {
      inherit (format) type;
      description = ''
        Configuration written to {file}`$XDG_CONFIG_HOME/discord/settings.json`.
      '';
      default = {};
    };

    openAsar.enable = mkEnableOption "OpenASAR";

    vencord = {
      enable = mkEnableOption "Vencord";

      settings = mkOption {
        inherit (format) type;
        description = ''
          Configuration written to {file}`$XDG_CONFIG_HOME/Vencord/settings/settings.json`.
        '';
        default = {};
      };

      css = mkOption {
        type = types.lines;
        description = ''
          Style sheet written to {file}`$XDG_CONFIG_HOME/Vencord/settings/quickCss.css`.
        '';
        default = "";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      (cfg.package.override {
        withOpenASAR = cfg.openAsar.enable;
        withVencord = cfg.vencord.enable;
      })
    ];

    xdg.configFile =
      {
        "discord/settings.json".source = format.generate "discord-settings.json" cfg.settings;
      }
      // optionalAttrs cfg.vencord.enable {
        "Vencord/settings/settings.json".source = format.generate "vencord-settings.json" cfg.vencord.settings;
        "Vencord/settings/quickCss.css".text = cfg.vencord.css;
      };
  };
}
