# All sorts of Qt 5/6 + GTK 3/4 pain and suffering
{
  pkgs,
  ...
}:
{
  hjem.users.leah.packages = with pkgs; [
    darkly
    darkly-qt5
    adw-gtk3
    adwaita-icon-theme
  ];

  # Theme Qt apps via qt{5,6}ct + Darkly
  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  # TODO: Declaratively configure qt*ct and GTK3/4 gsettings appearance flags

  # On native Wayland compositors that support text-input-v3
  # (incl. Niri), it's recommended to set this flag to true,
  # which removes environment variables like `GTK_IM_MODULES`
  # that are only present for backwards compatibility.
  i18n.inputMethod.fcitx5.waylandFrontend = true;
}
