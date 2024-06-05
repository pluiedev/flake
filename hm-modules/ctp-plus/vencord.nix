{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.programs.vencord.catppuccin;
  inherit (lib.ctp) mkCatppuccinOpt mkAccentOpt;

  settings = {
    themeLinks = [
      "https://raw.githubusercontent.com/catppuccin/discord/${inputs.ctp-discord-compiled.rev}/dist/catppuccin-${cfg.flavor}-${cfg.accent}.theme.css"
    ];

    plugins.ShikiCodeblocks.theme = "https://raw.githubusercontent.com/catppuccin/vscode/${inputs.ctp-vscode-compiled.rev}/${cfg.flavor}.json";
  };
in
{
  # TODO: separate options for Vencord + Discord and Vesktop
  options.programs.vencord.catppuccin = mkCatppuccinOpt "Vencord" // {
    accent = mkAccentOpt "Vencord";
  };

  # Reproducible 🔥🚀 tracking of latest theme version
  config = {
    programs.discord.vencord.settings = mkIf (
      cfg.enable && config.programs.discord.vencord.enable
    ) settings;
    programs.vesktop.vencord.settings = mkIf (cfg.enable && config.programs.vesktop.enable) settings;
  };
}
