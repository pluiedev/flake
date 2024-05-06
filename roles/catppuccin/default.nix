{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;
  inherit (config.roles.catppuccin) enable flavour accent;
in {
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
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
    catppuccin = {
      inherit flavour;
      enable = true;
    };
    hm = {
      imports = [inputs.catppuccin.homeManagerModules.catppuccin];

      catppuccin = {
        inherit accent flavour;
        enable = true;
      };
    };
  };
}
