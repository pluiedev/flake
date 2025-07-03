# Catppuccin theme for Fish
{
  config,
  ctp-lib,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ctp.fish;
  themeName = "Catppuccin ${ctp-lib.mkUpper cfg.flavor}";

  src = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "fish";
    rev = "6a85af2ff722ad0f9fbc8424ea0a5c454661dfed";
    hash = "sha256-Oc0emnIUI4LV7QJLs4B2/FQtCFewRFVp7EDv8GawFsA=";
  };
in
{
  options.ctp.fish = ctp-lib.mkCatppuccinOptions "Fish" { };

  config = lib.mkIf cfg.enable {
    files.".config/fish/themes/${themeName}.theme".source = "${src}/themes/${themeName}.theme";

    rum.programs.fish.earlyConfigFiles.ctp-fish = ''
      fish_config theme choose "${themeName}"
    '';
  };
}
