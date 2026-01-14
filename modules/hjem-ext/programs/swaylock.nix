{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ext.programs.swaylock;

  finalPackage = pkgs.writeShellApplication {
    name = "swaylock";
    runtimeInputs = [ cfg.package ];
    text = ''
      exec swaylock ${lib.cli.toCommandLineShellGNU { } cfg.settings} "$@"
    '';
  };
in
{
  options.ext.programs.swaylock = {
    enable = lib.mkEnableOption "Swaylock";

    package = lib.mkPackageOption pkgs "swaylock" { };

    finalPackage = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = finalPackage;
      description = ''
        The final package after all options have been applied.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType =
          with lib.types;
          attrsOf (oneOf [
            str
            bool
            int
            float
          ]);
      };
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [ finalPackage ];
  };
}
