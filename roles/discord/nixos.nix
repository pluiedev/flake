{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  cfg = config.roles.discord;
in {
  config = mkIf cfg.enable {
    hm.xdg.configFile = let
      vencordRoot =
        if cfg.vesktop.enable
        then "vesktop"
        else "Vencord";
    in
      mkMerge [
        (mkIf cfg.vencord.enable {
          "${vencordRoot}/settings/settings.json".text = builtins.toJSON cfg.vencord.settings;
          "${vencordRoot}/settings/quickCss.css".text = cfg.vencord.css;
        })
        (mkIf cfg.vesktop.enable {
          "${vencordRoot}/settings.json".text = builtins.toJSON cfg.vesktop.settings;
        })
      ];
  };
}
