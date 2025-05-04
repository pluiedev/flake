# Catppuccin theme for Fuzzel
{
  config,
  ctp-lib,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ctp.fuzzel;

  src = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "fuzzel";
    rev = "0af0e26901b60ada4b20522df739f032797b07c3";
    hash = "sha256-XpItMGsYq4XvLT+7OJ9YRILfd/9RG1GMuO6J4hSGepg=";
  };
in
{
  options.ctp.fuzzel = ctp-lib.mkCatppuccinOptions "Fuzzel" { withAccent = true; };

  config = lib.mkIf cfg.enable {
    rum.programs.fuzzel.settings.main.include =
      "${src}/themes/catppuccin-${cfg.flavor}/${cfg.accent}.ini";
  };
}
