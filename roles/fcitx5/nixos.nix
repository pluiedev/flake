{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf getExe';
  cfg = config.roles.fcitx5;

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
in {
  config = mkIf cfg.enable {
    hm = {
      i18n.inputMethod.enabled = "fcitx5";
      xdg.configFile."fcitx5/profile" = mkIf (cfg.settings != null) {
        text = mkFcitx5Cfg cfg.settings;
      };
    };

    roles.hyprland.settings.exec-once = [
      "${getExe' pkgs.fcitx5 "fcitx5"} -d --replace &"
    ];
  };
}
