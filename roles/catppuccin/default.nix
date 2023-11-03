{
  config,
  lib,
  ctp-nix,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;
  inherit (config.roles.catppuccin) enable flavour accent;
in {
  imports = [ctp-nix.nixosModules.catppuccin];

  options.roles.catppuccin = {
    enable = mkEnableOption "Catppuccin";

    flavour = mkOption {
      type = types.enum ["latte" "frappe" "macchiato" "mocha"];
      example = "mocha";
    };
    accent = mkOption {
      type = types.enum ["rosewater" "flamingo" "pink" "mauve" "red" "maroon" "peach" "yellow" "green" "teal" "sky" "sapphire" "blue" "lavender"];
      example = "maroon";
    };
  };

  config = mkIf enable {
    catppuccin = {inherit flavour;};
    hm = {
      catppuccin = {inherit accent flavour;};

      imports = [ctp-nix.homeManagerModules.catppuccin];

      xdg.enable = true;

      programs = {
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
    };

    roles.discord.vencord.settings = {
      themeLinks = ["https://catppuccin.github.io/discord/dist/catppuccin-${flavour}-${accent}.theme.css"];

      plugins.ShikiCodeblocks.theme = "https://raw.githubusercontent.com/catppuccin/vscode/6db6d747b2d2b5f21a6c8d5d2ea6ccbd5048c315/${flavour}.json";
    };
  };
}
