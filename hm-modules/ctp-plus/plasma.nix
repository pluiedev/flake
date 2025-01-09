{
  config,
  lib,
  ctpLib,
  pkgs,
  ...
}:
let
  cfg = config.programs.plasma.catppuccin;
  cursorCfg = config.catppuccin.cursors;
  enable = cfg.enable && config.programs.plasma.enable;

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
  options.programs.plasma.catppuccin = ctpLib.mkCatppuccinOption {
    name = "Plasma";
    accentSupport = true;
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
      colorScheme = "Catppuccin${ctpLib.mkUpper cfg.flavor}${ctpLib.mkUpper cfg.accent}";
      cursor.theme = lib.mkIf cursorCfg.enable "Catppuccin-${ctpLib.mkUpper cursorCfg.flavor}-${ctpLib.mkUpper cursorCfg.accent}-Cursors";
      inherit (darkModeSettings) lookAndFeel iconTheme;
    };
  };
}
