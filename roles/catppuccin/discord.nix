{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.roles.catppuccin) enable flavour accent;
  cfg = config.hm.programs.discord.catppuccin;

  vencord.settings = {
    themeLinks = ["https://raw.githubusercontent.com/catppuccin/discord/${inputs.ctp-discord-compiled.rev}/dist/catppuccin-${flavour}-${accent}.theme.css"];

    plugins.ShikiCodeblocks.theme = "https://raw.githubusercontent.com/catppuccin/vscode/${inputs.ctp-vscode-compiled.rev}/${flavour}.json";
  };
in {
  # TODO: make these "catppuccin-plus" options
  #options.hm.programs.discord.catppuccin.enable = mkEnableOption "Catppuccin theme" // {default = enable;};

  # Reproducible 🔥🚀 tracking of latest theme version
  hm.programs.discord = {inherit vencord;};
  hm.programs.vesktop = {inherit vencord;};
}
