{
  config,
  lib,
  ctpLib,
  pkgs,
  ...
}:
let
  cfg = config.programs.konsole.catppuccin;
  enable = cfg.enable && config.programs.konsole.enable;
in
{
  options.programs.konsole.catppuccin = ctpLib.mkCatppuccinOption { name = "Konsole"; } // {
    profileName = lib.mkOption {
      type = lib.types.str;
      default = "Catppuccin";
      example = "Catppuccin Custom";
      description = ''
        The name of the generated profile.
      '';
    };
    font = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Hack";
        example = "Hack";
        description = ''
          Name of the font the profile should use.
        '';
      };
      size = lib.mkOption {
        # The konsole ui gives you a limited range
        type = lib.types.ints.between 4 128;
        default = 10;
        example = 12;
        description = ''
          Size of the font.
          Needs a font to be set due to konsole limitations.
        '';
      };
    };
  };

  config = lib.mkIf enable {
    home.packages = [ (pkgs.catppuccin-konsole.override { flavors = [ cfg.flavor ]; }) ];

    programs.konsole = {
      defaultProfile = cfg.profileName;
      profiles.catppuccin = {
        name = cfg.profileName;
        colorScheme = "Catppuccin-${ctpLib.mkUpper cfg.flavor}";
        inherit (cfg) font;
      };
    };
  };
}
