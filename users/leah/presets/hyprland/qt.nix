{ lib, pkgs, ... }:
let
  settings = {
    Appearance = {
      icon_theme = "breeze-dark";
      standard_dialogs = "default";
      style = "Breeze";
    };
    Fonts = {
      fixed = "Monospace,11,-1,5,50,0,0,0,0,0";
      general = "Sans Serif,11,-1,5,50,0,0,0,0,0";
    };
    Interface = {
      double_click_interval = 400;
      cursor_flash_time = 1000;

      activate_item_on_single_click = 1;
      gui_effects = "@Invalid()";
      buttonbox_layout = 2; # KDE
      keyboard_scheme = 3; # KDE
      dialog_buttons_have_icons = 1;
      menus_have_icons = true;
      show_shortcuts_in_context_menus = true;
      underline_shortcut = 1;
      toolbutton_style = 4; # Follow the application style
      wheel_scroll_lines = 3;

      stylesheets = "@Invalid()";
    };
    Troubleshooting = {
      force_raster_widgets = 1;
      ignored_applications = "@Invalid()";
    };
  };
in
{
  hm.home.packages = with pkgs; [
    breeze-icons

    qt5.qtwayland
    qt6.qtwayland
  ];

  roles.qt = {
    platform = "qt5ct";

    qt5ct = {
      inherit settings;
    };
    qt6ct = {
      inherit settings;
    };
  };
}
