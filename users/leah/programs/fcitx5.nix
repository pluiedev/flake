{ pkgs, ... }:
let
  luna_pinyin = yaml.generate "luna_pinyin.yaml" {
    patch."speller/algebra" = [
      "erase/^xx$/"
      "derive/in$/ing/" # in/ing 不分
      "derive/ing$/in/"

      # 非标拼写就
      "derive/^([nl])ve$/$1ue/" # nve = nue, lve = lue
      "derive/^([jqxy])v/$1u/" # ju = jv
      "derive/uen$/un/" # gun = guen
      "derive/uei$/ui/" # gui = guei
      "derive/iou$/iu/" # jiu = jiou
    ];
  };

  yaml = pkgs.formats.yaml { };
in
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-rime
    ];
  };

  hjem.users.leah.files = {
    ".local/share/fcitx5/rime/default.custom.yaml".source = yaml.generate "default.yaml" {
      patch.schema_list = [
        { schema = "luna_pinyin_simp"; }
        { schema = "luna_pinyin"; }
      ];
    };
    ".local/share/fcitx5/rime/luna_pinyin.custom.yaml".source = luna_pinyin;
    ".local/share/fcitx5/rime/luna_pinyin_simp.custom.yaml".source = luna_pinyin;
  };

}
