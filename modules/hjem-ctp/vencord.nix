{
  config,
  lib,
  ctpLib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkMerge mkEnableOption;
  ctpCfg = config.catppuccin.vencord;

  mkConfig =
    cfg: xdgConfigPath: settingPath:
    let
      discordThemeFile = "catppuccin-${ctpCfg.flavor}-${ctpCfg.accent}.theme.css";

      # We get the latest stable version by reading the package.json. Cursed? Absolutely.
      vscodeVersion =
        (lib.importJSON "${inputs.ctp-vscode-compiled}/packages/catppuccin-vsc/package.json").version;

      palette =
        (lib.importJSON "${config.catppuccin.sources.palette}/palette.json").${ctpCfg.flavor}.colors;
    in
    mkIf (cfg.enable && ctpCfg.enable) {
      programs.${settingPath} = {
        vencord.settings = {
          enabledThemes = [ discordThemeFile ];
          plugins.ShikiCodeblocks.theme = "https://esm.sh/@catppuccin/vscode@${vscodeVersion}/themes/${ctpCfg.flavor}.json";
        };

        settings = mkIf (ctpCfg ? splashTheming && ctpCfg.splashTheming) {
          splashTheming = true;
          splashBackground = palette.base.hex;
          splashColor = palette.text.hex;
        };
      };

      xdg.configFile."${xdgConfigPath}/themes/${discordThemeFile}".source =
        "${inputs.ctp-discord-compiled}/dist/${discordThemeFile}";
    };
in
{
  # Reproducible 🔥🚀 tracking of latest theme version

  options.catppuccin.vencord = ctpLib.mkCatppuccinOption {
    name = "Vencord for Discord";
    accentSupport = true;
  };
  options.catppuccin.vesktop =
    ctpLib.mkCatppuccinOption {
      name = "Vencord for Vesktop";
      accentSupport = true;
    }
    // {
      splashTheming = mkEnableOption "Splash theming for Vesktop";
    };

  config = mkMerge [
    (mkConfig config.programs.discord.vencord "Vencord" "discord")
    (mkConfig config.programs.vesktop.vencord "vesktop" "vesktop")
  ];
}
