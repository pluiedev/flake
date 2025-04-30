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
in
{
  options.ctp.fish = ctp-lib.mkCatppuccinOptions "Fish" {};

  config = lib.mkIf cfg.enable {
    files = {
      ".config/fish/themes/${themeName}.theme".source =
        "${pkgs.catppuccin-fish}/share/fish/themes/${themeName}.theme";
    };

    rum.programs.fish.earlyConfigFiles.ctp-fish = ''
      fish_config theme choose "${themeName}"
    '';
  };
}
