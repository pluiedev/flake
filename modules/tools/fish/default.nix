{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) fromTOML readFile;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.pluie.tools.fish;
in {
  options.pluie.tools.fish.enable = mkEnableOption "Fish shell";

  config = mkIf cfg.enable {
    programs.fish.enable = true;

    users.users.${config.pluie.user.name}.shell = pkgs.fish;

    pluie.user.config.programs = {
      fish.enable = true;

      starship = {
        enable = true;
        settings = fromTOML (readFile ./starship.toml);
      };

      nix-index = {
        enable = true;
        enableFishIntegration = true;
      };
    };
  };
}
