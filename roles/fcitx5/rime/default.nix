{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption mapAttrs' nameValuePair types;
  cfg = config.roles.fcitx5.rime;

  mkRimeCfgs = mapAttrs' (
    n: v:
      nameValuePair "fcitx5/rime/${n}.custom.yaml" {text = lib.generators.toYAML {} v;}
  );
in {
  options.roles.fcitx5.rime = {
    enable = mkEnableOption "the Rime input engine for Fcitx5";

    settings = mkOption {
      type = types.attrsOf types.anything;
      default = {};
      example = {
        default.patch.schema_list = [
          {schema = "luna_pinyin_simp";}
          {schema = "luna_pinyin";}
        ];
      };
    };
  };

  config = mkIf cfg.enable {
    roles.fcitx5.addons = [pkgs.fcitx5-rime];
    hm.xdg.dataFile = mkRimeCfgs cfg.settings;
  };
}
