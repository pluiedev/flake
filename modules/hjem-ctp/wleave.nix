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

  # Generate the CSS required to override all icons
  # with their Catppuccin-ified counterparts
  iconsCss =
    lib.concatMapStrings
      (btn: ''
        #${btn} { background-image: url("${src}/icons/wleave/${cfg.flavor}/${cfg.accent}/${btn}.svg"); }
      '')
      [
        "lock"
        "logout"
        "suspend"
        "hibernate"
        "shutdown"
        "reboot"
      ];
in
{
  options.ctp.wleave = ctp-lib.mkCatppuccinOptions "wleave" {
    withAccent = true;
  };

  config = lib.mkIf cfg.enable {
    xdg.config.files."wleave/style.css".source = pkgs.concatText "wleave-style.css" [
      "${src}/themes/${cfg.flavor}/${cfg.accent}.css"
      (pkgs.writeText "wleave-icons.css" iconsCss)
    ];
  };
}
