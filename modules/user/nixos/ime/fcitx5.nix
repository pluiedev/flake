{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.pluie.user.ime;
  inherit (lib) mkIf mkOption types;

  mkFcitx5Cfg = {
    groups ? [],
    groupOrder ? builtins.catAttrs "name" groups,
  }: let
    inherit (builtins) listToAttrs;
    inherit (lib) flatten imap0 nameValuePair;

    mapItem = {
      name,
      layout,
      ...
    }: {
      Name = name;
      Layout = layout;
    };

    mapGroup = {
      name,
      defaultLayout,
      defaultIM,
      items,
      ...
    }: {
      Name = name;
      "Default Layout" = defaultLayout;
      DefaultIM = defaultIM;
    };

    mkItems = i: g:
      imap0 (
        n: item:
          nameValuePair "Group/${toString i}/Items/${toString n}" (mapItem item)
      )
      g.items;

    mkGroups = gs:
      flatten (imap0 (i: g:
        [(nameValuePair "Group/${toString i}" (mapGroup g))]
        ++ mkItems i g)
      gs);

    mkGroupOrder = go: listToAttrs (imap0 (i: nameValuePair (toString i)) go);
  in
    lib.generators.toINI {} (
      listToAttrs (mkGroups groups) // {GroupOrder = mkGroupOrder groupOrder;}
    );

  fcitx5ProfileModule.options = let
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
  options.pluie.user.ime.fcitx5 = {
    profile = mkOption {
      type = types.nullOr (types.submodule fcitx5ProfileModule);
      default = {
        groups = [
          {
            name = "Default";
            defaultLayout = "us";
            defaultIM = "keyboard-us";
            items = map (name: {inherit name;}) (["keyboard-us"] ++ cfg.engines);
          }
        ];
      };
    };
  };

  config = mkIf (cfg.enabled == "fcitx5") {
    i18n.inputMethod.fcitx5.addons = map (x: pkgs.${"fcitx5-${x}"}) cfg.engines;

    xdg.configFile."fcitx5/profile".text =
      mkIf
      (cfg.fcitx5.profile != null)
      (mkFcitx5Cfg cfg.fcitx5.profile);
  };
}
