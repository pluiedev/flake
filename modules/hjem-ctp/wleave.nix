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
    repo = "wlogout";
    rev = "b51d7189efb414fc76cb6c08f27c0c69706b9f78";
    hash = "sha256-0VCk+7t/cSEmcnfvKdxUDwwrtK0VLhZrVpw4enoBEbc=";
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
