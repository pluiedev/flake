{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.roles.catppuccin;

  toTitle = s: lib.toUpper (builtins.substring 0 1 s) + builtins.substring 1 (builtins.stringLength s) s;

  inherit (cfg) variant accent;
  Variant = toTitle cfg.variant;
  Accent = toTitle cfg.accent;
in {
  hm = {
    gtk = {
      enable = true;
      cursorTheme = {
        name = "Catppuccin-${Variant}-${Accent}";
        package = pkgs.catppuccin-cursors.${variant + Accent};
        size = 24;
      };
      theme = {
        name = "Catppuccin-${Variant}-Compact-${Accent}-Dark";

        package = pkgs.catppuccin-gtk.override {
          inherit variant;
          tweaks = ["rimless"];
          size = "compact";
          accents = [accent];
        };
      };
    };

    programs.kitty.theme = "Catppuccin-${Variant}";

    programs.fuzzel.settings.colors = {
      background = "11111bff";
      text = "cdd6f4ff";
      match = "a6e3a1ff";
      selection = "f5e0dcff";
      selection-text = "1e1e2eff";
      selection-match = "1f7f18ff";
      border = "eba0acee";
    };
  };

  roles.qt.theme = "${pkgs.catppuccin-qtct}/share/qt5ct/colors/Catppuccin-${Variant}.conf";

  roles.discord.vencord.settings = {
    themeLinks = ["https://catppuccin.github.io/discord/dist/catppuccin-${variant}-${accent}.theme.css"];

    plugins.ShikiCodeblocks.theme = "https://raw.githubusercontent.com/catppuccin/vscode/6db6d747b2d2b5f21a6c8d5d2ea6ccbd5048c315/${variant}.json";
  };
}
