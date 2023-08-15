{
  config,
  lib,
  ...
}: let
  cfg = config.pluie.user.ime;
  inherit (lib) mkIf mapAttrs' nameValuePair;

  mkRimeCfgs = mapAttrs' (
    n: v:
      nameValuePair "${cfg.enabled}/rime/${n}.custom.yaml" {text = lib.generators.toYAML {} v;}
  );

  rimeCfgs = mkRimeCfgs rec {
    default.patch.schema_list = [
      {schema = "luna_pinyin_simp";}
      {schema = "luna_pinyin";}
    ];
    luna_pinyin.patch."speller/algebra" = [
      "erase/^xx$/"
      "derive/in$/ing/" # in/ing 不分
      "derive/ing$/in/"

      # 非标拼写
      "derive/^([nl])ve$/$1ue/" # nve = nue, lve = lue
      "derive/^([jqxy])v/$1u/" # ju = jv
      "derive/uen$/un/" # gun = guen
      "derive/uei$/ui/" # gui = guei
      "derive/iou$/iu/" # jiu = jiou
    ];
    luna_pinyin_simp = luna_pinyin;
  };
in {
  config = mkIf (builtins.elem "rime" cfg.engines) {
    pluie.user.config = {
      xdg.dataFile = mkIf (cfg.enabled == "fcitx5") rimeCfgs;
      xdg.configFile = mkIf (cfg.enabled == "ibus") rimeCfgs;
    };
  };
}
