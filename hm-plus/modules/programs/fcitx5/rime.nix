{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption mapAttrs' nameValuePair types;
  cfg = config.i18n.inputMethod.fcitx5.rime;
  format = pkgs.formats.yaml {};
in {
  options.i18n.inputMethod.fcitx5.rime = {
    enable = mkEnableOption "the Rime input engine for Fcitx5";

    dataPkgs = mkOption {
      type = types.listOf types.package;
      default = [pkgs.rime-data];
    };

    settings = mkOption {
      inherit (format) type;
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
    i18n.inputMethod.fcitx5.addons = [
      (pkgs.fcitx5-rime.override {
        rimeDataPkgs = cfg.dataPkgs;
      })
    ];
    xdg.dataFile =
      mapAttrs' (
        n: v:
          nameValuePair "fcitx5/rime/${n}.custom.yaml" {source = format.generate n v;}
      )
      cfg.settings;
  };
}
