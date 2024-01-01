{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.roles.fcitx5;
  toINI = lib.generators.toINI {};
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
          nameValuePair "Groups/${toString i}/Items/${toString n}" (mapItem item)
      )
      g.items;

    mkGroups = gs:
      flatten (imap0 (i: g:
        [(nameValuePair "Groups/${toString i}" (mapGroup g))]
        ++ mkItems i g)
      gs);

    mkGroupOrder = go: listToAttrs (imap0 (i: nameValuePair (toString i)) go);
  in
    toINI (
      listToAttrs (mkGroups groups) // {GroupOrder = mkGroupOrder groupOrder;}
    );
in {
  config = mkIf cfg.enable {
    hm.i18n.inputMethod.enabled = "fcitx5";
    hm.xdg.configFile = {
      "fcitx5/profile" = mkIf (cfg.settings != null) {
        text = mkFcitx5Cfg cfg.settings;
      };
      "fcitx5/conf/classicui.conf" = mkIf (cfg.theme != null) {
        text = toINI {Theme = cfg.theme;};
      };
    };
  };
}
