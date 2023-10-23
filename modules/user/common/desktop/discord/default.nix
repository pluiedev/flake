{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf mkMerge types;
  cfg = config.pluie.user.desktop.discord;
in {
  options.pluie.user.desktop.discord = {
    enable = mkEnableOption "Discord";

    package = mkOption {
      type = types.package;
      default =
        if (cfg.vesktop.enable)
        then pkgs.vesktop
        else
          pkgs.discord.override {
            withOpenASAR = cfg.openAsar.enable;
            withVencord = cfg.vencord.enable;
          };
      example = pkgs.discord;
    };

    openAsar.enable = mkEnableOption "OpenASAR";

    vencord = {
      enable = mkOption {
        type = types.bool;
        default = cfg.vesktop.enable;
        description = "Whether to enable Vencord.";
      };
      settings = mkOption {
        type = types.attrsOf types.anything;
        default = {};
      };
      css = mkOption {
        type = types.lines;
        default = "";
      };
    };

    vesktop = {
      enable = mkEnableOption "Vesktop, an alternative Discord client";
      settings = mkOption {
        type = types.attrsOf types.anything;
        default = {};
      };
    };
  };

  # TODO: make vesktop conflict with openasar
  config = let
    vencordRoot =
      if (cfg.vesktop.enable)
      then "VencordDesktop/VencordDesktop"
      else "Vencord";
  in
    mkIf cfg.enable {
      home.packages = [cfg.package];

      assertions = [
        {
          assertion = cfg.vesktop.enable -> !cfg.openAsar.enable;
          message = "Vesktop is incompatible with OpenASAR";
        }
        {
          assertion = cfg.vesktop.enable -> cfg.vencord.enable;
          message = "Vencord must be enabled when using Vesktop";
        }
      ];

      xdg.configFile = mkMerge [
        (mkIf cfg.vencord.enable {
          "${vencordRoot}/settings/settings.json".text = builtins.toJSON cfg.vencord.settings;
          "${vencordRoot}/settings/quickCss.css".text = cfg.vencord.css;
        })
        (mkIf cfg.vesktop.enable {
          # TODO: broken
          #"${vencordRoot}/settings.json".text = builtins.toJSON cfg.vesktop.settings;
        })
      ];
    };
}
