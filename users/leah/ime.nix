_: let
  fuzzySpelling = ''
    patch:
      'speller/algebra':
        - erase/^xx$/
        - derive/in$/ing/ # in/ing 不分
        - derive/ing$/in/

        # 非标拼写
        - derive/^([nl])ve$/$1ue/          # nve = nue, lve = lue
        - derive/^([jqxy])v/$1u/           # ju = jv
        - derive/uen$/un/                  # gun = guen
        - derive/uei$/ui/                  # gui = guei
        - derive/iou$/iu/                  # jiu = jiou
  '';
in {
  xdg.dataFile."fcitx5/rime/default.custom.yaml".text = ''
    patch:
      schema_list:
        - schema: luna_pinyin_simp
        - schema: luna_pinyin
  '';
  xdg.dataFile."fcitx5/rime/luna_pinyin.custom.yaml".text = fuzzySpelling;
  xdg.dataFile."fcitx5/rime/luna_pinyin_simp.custom.yaml".text = fuzzySpelling;
}
