{
  config,
  lib,
  ...
}: let
  inherit (config.roles.catppuccin) enable;
in {
  config = lib.mkIf enable {
    hm.gtk = {
      enable = true;
      catppuccin = {
        enable = true;
        tweaks = ["rimless"];
        size = "compact";
        cursor.enable = true;
      };

      cursorTheme.size = 24;
    };

    hm.wayland.windowManager.hyprland.catppuccin.enable = true;

    # see catppuccin/tty
    console.colors = [
      "1e1e2e"
      "f38ba8"
      "a6e3a1"
      "f9e2af"
      "89b4fa"
      "f5c2e7"
      "94e2d5"
      "bac2de"
      "585b70"
      "f38ba8"
      "a6e3a1"
      "f9e2af"
      "89b4fa"
      "f5c2e7"
      "94e2d5"
      "a6adc8"
    ];
  };
}
