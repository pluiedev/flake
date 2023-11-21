{pkgs, ...}: {
  roles.fcitx5 = {
    enable = true;

    addons = [pkgs.fcitx5-mozc];

    settings.groups = [
      {
        name = "Default";
        defaultLayout = "us";
        defaultIM = "keyboard-us";
        items = map (name: {inherit name;}) ["keyboard-us" "rime" "mozc"];
      }
    ];

    rime = {
      enable = true;
      settings = let
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
      in {
        default.patch.schema_list = [
          {schema = "luna_pinyin_simp";}
          {schema = "luna_pinyin";}
        ];
        inherit luna_pinyin;
        luna_pinyin_simp = luna_pinyin;
      };
    };
  };
}
