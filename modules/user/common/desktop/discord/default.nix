{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.pluie.user.desktop.discord;
in {
  options.pluie.user.desktop.discord = {
    enable = mkEnableOption "Discord";

    package = mkOption {
      type = types.package;
      default = pkgs.discord.override {
        withOpenASAR = cfg.openAsar.enable;
        withVencord = cfg.vencord.enable;
      };
      example = pkgs.discord;
    };

    openAsar.enable = mkEnableOption "OpenASAR";

    vencord = {
      enable = mkEnableOption "Vencord";
      settings = mkOption {
        type = types.attrsOf types.anything;
        default = builtins.fromJSON (builtins.readFile ./vencord/settings.json);
      };
      css = mkOption {
        type = types.lines;
        default = builtins.readFile ./vencord/quickCss.css;
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];
    xdg.configFile = {
      "Vencord/settings/settings.json".text = builtins.toJSON cfg.vencord.settings;
      "Vencord/settings/quickCss.css".text = cfg.vencord.css;
    };
  };
}
