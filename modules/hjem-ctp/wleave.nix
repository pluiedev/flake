# Catppuccin theme for wleave
{
  config,
  ctp-lib,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ctp.wleave;

  src = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "wleave";
    rev = "b690cee13b944890e43a5fb629ccdff86cffbbb3";
    hash = "sha256-QUSDx5M+BG7YqI4MBsOKFPxvZHQtCa8ibT0Ln4FPQ7I=";
  };
in
{
  options.ctp.wleave = ctp-lib.mkCatppuccinOptions "wleave" {
    withAccent = true;
  };

  config = lib.mkIf cfg.enable {
    xdg.config.files = {
      "wleave/style.css".source = "${src}/themes/${cfg.flavor}/${cfg.accent}.css";
    };
  };
}
