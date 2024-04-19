{
  config,
  lib,
  catppuccin,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault mkOption types;
  inherit (config.roles.catppuccin) enable flavour accent;
in {
  imports = [
    catppuccin.nixosModules.catppuccin
    ./discord.nix
    ./sddm.nix
  ];

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

      imports = [catppuccin.homeManagerModules.catppuccin];

      i18n.inputMethod.fcitx5.catppuccin.enable = true;

      programs = {
        bat.catppuccin.enable = mkDefault true;
        fish.catppuccin.enable = mkDefault true;
        kitty.catppuccin.enable = mkDefault true;

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
  };
}
