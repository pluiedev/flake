{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.ext.programs.direnv;
in
{
  options.ext.programs.direnv = {
    enable = lib.mkEnableOption "direnv";
    package = lib.mkPackageOption pkgs "direnv" { };

    nix-direnv = {
      enable = lib.mkEnableOption "nix-direnv";
      package = lib.mkPackageOption pkgs "nix-direnv" { };
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [ cfg.package ];

    rum.programs.fish.earlyConfigFiles.direnv = ''
      ${lib.getExe cfg.package} hook fish | source
    '';

    xdg.config.files."direnv/lib/hm-nix-direnv.sh".source =
      lib.mkIf cfg.nix-direnv.enable "${cfg.nix-direnv.package}/share/nix-direnv/direnvrc";
  };
}
