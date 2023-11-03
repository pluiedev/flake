{lib, ...}: let
  inherit (lib) mkEnableOption mkOption types;
in {
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
}
