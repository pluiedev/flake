# All sorts of Qt 5/6 + GTK 3/4 pain and suffering
{
  pkgs,
  ...
}:
{
  hjem.users.leah.packages = with pkgs; [
    qadwaitadecorations
    qadwaitadecorations-qt6
  ];

  qt.enable = true;
  environment.variables.QT_QPA_PLATFORMTHEME = "adwaita";

  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/wm/preferences" = {
          # Both minimize and maximize do nothing in niri
          button-layout = "icon:close";
        };
      };
    }
  ];

  # On native Wayland compositors that support text-input-v3
  # (incl. Niri), it's recommended to set this flag to true,
  # which removes environment variables like `GTK_IM_MODULES`
  # that are only present for backwards compatibility.
  i18n.inputMethod.fcitx5.waylandFrontend = true;
}
