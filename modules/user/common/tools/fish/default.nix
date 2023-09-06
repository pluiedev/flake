{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) fromTOML readFile;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.pluie.user.tools.fish;
in {
  options.pluie.user.tools.fish.enable = mkEnableOption "Fish shell";

  config = mkIf cfg.enable {
    programs = {
      # we have login shells at home
      bash.initExtra = "exec ${lib.getExe config.programs.fish.package}";

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
