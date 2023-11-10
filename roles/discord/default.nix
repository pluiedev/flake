{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.roles.discord;
in {
  options.roles.discord = {
    enable = mkEnableOption "Discord";

    package = mkOption {
      type = types.package;
      description = "The package to use for Discord. Defaults to Vesktop if it is enabled, or the official client if it is not.";

      default =
        if cfg.vesktop.enable
        then pkgs.vesktop
        else
          pkgs.discord.override {
            withOpenASAR = cfg.openAsar.enable;
            withVencord = cfg.vencord.enable;
          };
    };

    openAsar.enable = mkEnableOption "OpenASAR";

    vencord = {
      enable =
        mkEnableOption "Vencord"
        // {
          default = cfg.vesktop.enable;
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

  config = mkIf cfg.enable {
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

    hm.home.packages = [cfg.package];
  };
}
