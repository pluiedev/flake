{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.pluie.user.ime;
  inherit (lib) mkEnableOption mkOption mkIf mkMerge mapAttrs' nameValuePair types;

  mkRimeCfgs = let
    toYAML = lib.generators.toYAML {};
  in
    mapAttrs' (n: v: nameValuePair "${cfg.backend}/rime/${n}.custom.yaml" {text = toYAML v;});

  rimeCfgs = mkRimeCfgs rec {
    default = {
      patch.schema_list = [
        {schema = "luna_pinyin_simp";}
        {schema = "luna_pinyin";}
      ];
    };
    luna_pinyin = {
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
    luna_pinyin_simp = luna_pinyin;
  };

  mkFcitx5Cfg = {
    groups,
    groupOrder ? builtins.catAttrs "name" groups,
  }: let
    inherit (builtins) listToAttrs removeAttrs;
    inherit (lib) flatten imap0 nameValuePair;

    toINI = lib.generators.toINI {};

    mkItems = i: g: imap0 (n: nameValuePair "Group/${i}/Items/${n}") g.items;

    mkGroups = gs:
      flatten (imap0 (i: g:
        [(nameValuePair "Group/${i}" (removeAttrs g ["items"]))]
        ++ mkItems i g)
      gs);

    mkGroupOrder = imap0 (i: nameValuePair "${i}");
  in
    toINI (listToAttrs (mkGroups groups ++ mkGroupOrder groupOrder));
  /*
  fcitx5Cfgs."fcitx5/profile".text = mkFcitx5Cfg {
    groups = [
      {
        Name = "Default";
        "Default Layout" = "us";
        DefaultIM = "keyboard-us";
        items = [
          {
            Name = "keyboard-us";
            Layout = "";
          }
          {
            Name = "rime";
            Layout = "us";
          }
          {
            Name = "mozc";
            Layout = "us";
          }
        ];
      }
    ];
  };
  */
in {
  options.pluie.user.ime = {
    enable = mkEnableOption "IMEs";

    backend = mkOption {
      type = types.enum ["fcitx5" "ibus"];
      default = "fcitx5";
      example = "ibus";
      description = "The IME backend to use.";
    };
  };

  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enabled = cfg.backend;

      fcitx5.addons = mkIf (cfg.backend == "fcitx5") (with pkgs; [
        fcitx5-mozc
        fcitx5-rime
      ]);

      ibus.engines = mkIf (cfg.backend == "ibus") (with pkgs.ibus-engines; [
        mozc
        rime
      ]);
    };

    pluie.user.config = {
      xdg.dataFile = mkIf (cfg.backend == "fcitx5") rimeCfgs;
      xdg.configFile = mkMerge [
        #(mkIf (cfg.backend == "fcitx5") fcitx5Cfgs)
        (mkIf (cfg.backend == "ibus") rimeCfgs)
      ];
    };
  };
}
