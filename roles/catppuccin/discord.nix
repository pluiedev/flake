{
  config,
  lib,
  ctp-discord-compiled,
  ctp-vscode-compiled,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.roles.catppuccin) enable flavour accent;
  cfg = config.roles.discord.catppuccin;
in {
  options.roles.discord.catppuccin.enable = mkEnableOption "Catppuccin theme" // {default = enable;};

  config = mkIf (cfg.enable) {
    # Reproducible 🔥🚀 tracking of latest theme version
    roles.discord.vencord.settings = {
      themeLinks = ["https://raw.githubusercontent.com/catppuccin/discord/${ctp-discord-compiled.rev}/dist/catppuccin-${flavour}-${accent}.theme.css"];

      plugins.ShikiCodeblocks.theme = "https://raw.githubusercontent.com/catppuccin/vscode/${ctp-vscode-compiled.rev}/${flavour}.json";
    };
  };
}
