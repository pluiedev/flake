{
  pkgs,
  ...
}:
{
  imports = [
    ./gui-toolkits.nix
    ./services.nix
  ];

  programs.niri.enable = true;

  hjem.users.leah = {
    packages = with pkgs; [
      # I'm using Nautilus here because it a) looks nice
      # and b) avoids configuring XDP GNOME to use a XDP GTK's file chooser
      nautilus

      networkmanagerapplet
      swaynotificationcenter
      waybar
      xwayland-satellite
      brightnessctl

      # Desktop utilities
      file-roller
      loupe
      gnome-logs
      resources
    ];

    files.".config/niri/config.kdl".source = ./config.kdl;

    files.".config/swaync/style.css".source = ./swaync/style.css;
    files.".config/swaync/config.json".source = ./swaync/config.json;

    files.".config/waybar/style.css".source = ./waybar/style.css;
    files.".config/waybar/config.jsonc".source = ./waybar/config.jsonc;
  };

  hjem.users.leah.rum.programs.fuzzel = {
    enable = true;

    settings.main = {
      font = "Sans:size=8";
      use-bold = true;
      dpi-aware = "yes";
      show-actions = true;
      lines = 10;
      keyboard-focus = "on-demand";
      horizontal-pad = 32;
      vertical-pad = 24;
      anchor = "bottom";
      layer = "top";
    };
  };
}
