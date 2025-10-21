
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
    repo = "eza";
    rev = "70f805f6cc27fa5b91750b75afb4296a0ec7fec9";
    hash = "sha256-Q+C07IReQQBO5xYuFiFbS1wjmO4gdt/wIJWHNwIizSc=";
  };
in
{
  options.ctp.eza = ctp-lib.mkCatppuccinOptions "eza" { withAccent = true; };

  config = lib.mkIf cfg.enable {
    xdg.config.files."eza/theme.yml".source =
      "${src}/themes/${cfg.flavor}/catppuccin-${cfg.flavor}-${cfg.accent}.yml";
  };
}
