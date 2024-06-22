{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.plasma.catppuccin;
  cursorCfg = config.gtk.catppuccin.cursor;
  enable = cfg.enable && config.programs.plasma.enable;

  inherit (lib.ctp) mkCatppuccinOpt mkAccentOpt mkUpper;

  darkModeSettings =
    if cfg.flavor == "latte" then
      {
        lookAndFeel = "org.kde.breeze.desktop";
        iconTheme = "breeze";
      }
    else
      {
        lookAndFeel = "org.kde.breezedark.desktop";
        iconTheme = "breeze-dark";
      };
in
{
  options.programs.plasma.catppuccin = mkCatppuccinOpt "Plasma" // {
    accent = mkAccentOpt "Plasma";
  };

  config = lib.mkIf enable {
    home.packages = with pkgs; [
      (catppuccin-kde.override {
        flavour = [ cfg.flavor ];
        accents = [ cfg.accent ];
      })
    ];

    programs.plasma.workspace = {
      theme = "default"; # Actually Catppuccin
      colorScheme = "Catppuccin${mkUpper cfg.flavor}${mkUpper cfg.accent}";
      cursor.theme = lib.mkIf cursorCfg.enable "Catppuccin-${mkUpper cursorCfg.flavor}-${mkUpper cursorCfg.accent}-Cursors";
      inherit (darkModeSettings) lookAndFeel iconTheme;
    };
  };
}
