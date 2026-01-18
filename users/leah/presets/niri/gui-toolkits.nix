# All sorts of Qt 5/6 + GTK 3/4 pain and suffering
{
  pkgs,
  ...
}:
{
  # Make both GTK 3 and Qt apps follow GTK 4-like theming... sorta
  hjem.users.leah = {
    packages = with pkgs; [
      adw-gtk3
      qadwaitadecorations
      qadwaitadecorations-qt6
    ];

    environment.sessionVariables = {
      # Make Qt apps look like GTK 3 apps.
      # Ideally I want to make them look like GTK 4 + Adwaita apps instead,
      # but it's not really viable with `adwaita-qt` being discontinued
      QT_QPA_PLATFORMTHEME = "gtk3";

      # At least we can have an Adwaita-style CSD
      QT_WAYLAND_DECORATION = "adwaita";
    };

    rum.misc.gtk.settings = {
      # GTK 3 apps are ignoring the dconf settings for some reason,
      # which is causing Qt apps to also misbehave
      application-prefer-dark-theme = true;
    };
  };

  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/wm/preferences" = {
          # Both minimize and maximize do nothing in niri
          button-layout = ":menu,close";
        };
        "org/gnome/desktop/interface" = {
          accent-color = "pink";
          gtk-theme = "Adwaita";
          color-scheme = "prefer-dark";
          font-name = "Manrope V5 13";
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
