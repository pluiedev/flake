{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.pluie.desktop.ime;
  inherit (lib) mkEnableOption mkIf;
  toYAML = builtins.toJSON; # YAML is a superset of JSON anyway

  fuzzySpelling.text = toYAML {
    patch."speller/algebra" = [
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
  };
in {
  options.pluie.desktop.ime.enable = mkEnableOption "IMEs with Fcitx5";

  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-rime
      ];
    };
    pluie.user.config.xdg.dataFile = {
      "fcitx5/rime/default.custom.yaml".text = builtins.toJSON {
        patch.schema_list = [
          {schema = "luna_pinyin_simp";}
          {schema = "luna_pinyin";}
        ];
      };
      "fcitx5/rime/luna_pinyin.custom.yaml" = fuzzySpelling;
      "fcitx5/rime/luna_pinyin_simp.custom.yaml" = fuzzySpelling;
    };
  };
}
