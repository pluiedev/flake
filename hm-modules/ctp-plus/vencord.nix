{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkMerge mkEnableOption;
  inherit (lib.ctp) mkCatppuccinOpt mkAccentOpt;

  mkConfig =
    cfg:
    xdgConfigPath:
    settingPath:
    let
      discordThemeFile = "catppuccin-${cfg.catppuccin.flavor}-${cfg.catppuccin.accent}.theme.css";

      # We get the latest stable version by reading the package.json. Cursed? Absolutely.
      vscodeVersion = (lib.importJSON "${inputs.ctp-vscode-compiled}/packages/catppuccin-vsc/package.json").version;

      palette = (lib.importJSON "${config.catppuccin.sources.palette}/palette.json").${cfg.catppuccin.flavor}.colors;
    in
    mkIf (cfg.enable && cfg.catppuccin.enable) {
      programs.${settingPath} = {
        vencord.settings = {
          enabledThemes = [ discordThemeFile ];
          plugins.ShikiCodeblocks.theme = "https://esm.sh/@catppuccin/vscode@${vscodeVersion}/themes/${cfg.catppuccin.flavor}.json";
        };

        settings = mkIf (cfg.catppuccin ? splashTheming && cfg.catppuccin.splashTheming) {
          splashTheming = true;
          splashBackground = palette.base.hex;
          splashColor = palette.text.hex;
        };
      };

      xdg.configFile."${xdgConfigPath}/themes/${discordThemeFile}".source = "${inputs.ctp-discord-compiled}/dist/${discordThemeFile}";
    };
in
{
  # Reproducible 🔥🚀 tracking of latest theme version

  options.programs.discord.vencord.catppuccin = mkCatppuccinOpt "Vencord for Discord" // {
    accent = mkAccentOpt "Vencord for Discord";
  };
  options.programs.vesktop.vencord.catppuccin = mkCatppuccinOpt "Vencord for Vesktop" // {
    accent = mkAccentOpt "Vencord for Vesktop";

    splashTheming = mkEnableOption "Splash theming for Vesktop";
  };

  config = lib.traceSeq inputs.ctp-vscode-compiled (mkMerge [
    (mkConfig config.programs.discord.vencord "Vencord" "discord")
    (mkConfig config.programs.vesktop.vencord "vesktop" "vesktop")
  ]);
}
