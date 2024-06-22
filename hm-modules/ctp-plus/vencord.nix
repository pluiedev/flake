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
      vscodeTheme = lib.importJSON "${inputs.ctp-vscode-compiled}/${cfg.catppuccin.flavor}.json";
    in
    mkIf (cfg.enable && cfg.catppuccin.enable) {
      programs.${settingPath} = {
        vencord.settings = {
          enabledThemes = [ discordThemeFile ];
          plugins.ShikiCodeblocks.theme = "https://esm.sh/@catppuccin/vscode@3.14.0/themes/${cfg.catppuccin.flavor}.json";
        };

        settings = mkIf (cfg.catppuccin ? splashTheming && cfg.catppuccin.splashTheming) {
          splashTheming = true;
          splashBackground = vscodeTheme.colors."editor.background";
          splashColor = vscodeTheme.colors."editor.foreground";
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

  config = mkMerge [
    (mkConfig config.programs.discord.vencord "Vencord" "discord")
    (mkConfig config.programs.vesktop.vencord "vesktop" "vesktop")
  ];
}
