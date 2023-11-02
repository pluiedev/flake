{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;

  settingsModule.options = let
    groupModule.options = {
      name = mkOption {
        type = types.str;
        default = "Default";
      };
      defaultLayout = mkOption {
        type = types.str;
        default = "";
      };
      defaultIM = mkOption {
        type = types.str;
        default = "";
      };
      items = mkOption {
        type = types.listOf (types.submodule itemModule);
        default = [];
      };
    };
    itemModule.options = {
      name = mkOption {
        type = types.str;
      };
      layout = mkOption {
        type = types.str;
        default = "";
      };
    };
  in {
    groups = mkOption {
      type = types.listOf (types.submodule groupModule);
      default = [];
    };
  };
in {
  imports = [
    ./rime.nix
    (lib.mkAliasOptionModule ["roles" "fcitx5" "addons"] ["hm" "i18n" "inputMethod" "fcitx5" "addons"])
  ];

  options.roles.fcitx5 = {
    enable = mkEnableOption "Fcitx5";

    settings = mkOption {
      type = types.nullOr (types.submodule settingsModule);
      default = null;
    };
  };
}
