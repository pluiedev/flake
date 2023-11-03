{
  pkgs,
  config,
  lib,
  ctp-nix,
  ...
}: let
  inherit (config.roles.catppuccin) enable flavour accent;

  mkUpper = str:
    with builtins;
      (lib.toUpper (substring 0 1 str)) + (substring 1 (stringLength str) str);
  Flavour = mkUpper flavour;
in {
  imports = [
    ctp-nix.nixosModules.catppuccin
  ];

  config = lib.mkIf enable {
    catppuccin = {inherit flavour;};
    hm.catppuccin = {inherit accent flavour;};

    hm.imports = [ctp-nix.homeManagerModules.catppuccin];

    hm.gtk = {
      enable = true;
      catppuccin = {
        enable = true;
        tweaks = ["rimless"];
        size = "compact";
        cursor.enable = true;
      };

      cursorTheme.size = 24;
    };

    hm.programs = {
      fish.catppuccin.enable = true;
      kitty.catppuccin.enable = true;

      fuzzel.settings.colors = {
        background = "11111bff";
        text = "cdd6f4ff";
        match = "a6e3a1ff";
        selection = "f5e0dcff";
        selection-text = "1e1e2eff";
        selection-match = "1f7f18ff";
        border = "eba0acee";
      };
    };

    hm.xdg.enable = true;

    roles.qt.theme = "${pkgs.catppuccin-qtct}/share/qt5ct/colors/Catppuccin-${Flavour}.conf";

    roles.discord.vencord.settings = {
      themeLinks = ["https://catppuccin.github.io/discord/dist/catppuccin-${flavour}-${accent}.theme.css"];

      plugins.ShikiCodeblocks.theme = "https://raw.githubusercontent.com/catppuccin/vscode/6db6d747b2d2b5f21a6c8d5d2ea6ccbd5048c315/${flavour}.json";
    };
  };
}
