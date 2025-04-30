{
  config,
  ctp-lib,
  lib,
  ...
}:
let
  cfg = config.ctp.vesktop;
in
{
  # Reproducible 🔥🚀 tracking of latest theme version
  options.ctp.vesktop = ctp-lib.mkCatppuccinOptions "Vesktop" { withAccent = true; };

  config = lib.mkIf cfg.enable {
    ext.programs.vesktop.vencord.settings = {
      themeLinks = [
        "https://catppuccin.github.io/discord/dist/catppuccin-${cfg.flavor}-${cfg.accent}.theme.css"
      ];
      plugins.ShikiCodeblocks.theme = "https://esm.sh/@catppuccin/vscode@latest/themes/${cfg.flavor}.json";
    };
  };
}
