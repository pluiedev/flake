{
  config,
  lib,
  ...
}:
{
  mkUpper = str: (lib.toUpper (lib.substring 0 1 str)) + (lib.substring 1 (lib.stringLength str) str);

  mkCatppuccinOptions =
    name:
    {
      inheritFrom ? config.ctp,
      withAccent ? false,
    }:
    {
      enable =
        lib.mkEnableOption "Catppuccin for ${name}"
        // lib.optionalAttrs (inheritFrom != { }) {
          default = inheritFrom.enable;
        };

      flavor =
        lib.mkOption {
          type = lib.types.enum [
            "latte"
            "frappe"
            "macchiato"
            "mocha"
          ];
        }
        // lib.optionalAttrs (inheritFrom != { }) {
          default = inheritFrom.flavor;
        };
    }
    // lib.optionalAttrs withAccent {
      accent =
        lib.mkOption {
          type = lib.types.enum [
            "blue"
            "flamingo"
            "green"
            "lavender"
            "maroon"
            "mauve"
            "peach"
            "pink"
            "red"
            "rosewater"
            "sapphire"
            "sky"
            "teal"
            "yellow"
          ];
        }
        // lib.optionalAttrs (inheritFrom != { }) {
          default = inheritFrom.accent;
        };
    };
}
