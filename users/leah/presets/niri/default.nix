{
  pkgs,
  ...
}:
{
  imports = [
    ./gui-toolkits.nix
    ./services.nix
    ./waybar
  ];

  programs.niri.enable = true;

  services.udev.packages = [ pkgs.swayosd ];  
  systemd.packages = [ pkgs.swayosd ];  

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
      wleave

      # Desktop utilities
      file-roller
      loupe
      gnome-logs
      resources
    ];

    xdg.config.files = {
      "niri/config.kdl".source = ./config.kdl;
      "swaync/style.css".source = ./swaync/style.css;
      "swaync/config.json".source = ./swaync/config.json;
    };
  };

  hjem.users.leah.rum.programs.fuzzel = {
    enable = true;

    settings.main = {
      font = "Sans:size=14";
      use-bold = true;
      show-actions = true;
      match-counter = true;

      # Make Fuzzel take on-demand focus and stop it
      # from closing automatically
      keyboard-focus = "on-demand";
      exit-on-keyboard-focus-loss = false;

      lines = 8;
      y-margin = 8;
      horizontal-pad = 20;
      vertical-pad = 16;
      inner-pad = 8;
      anchor = "bottom";
      layer = "top";
    };

    settings.border = {
      radius = 8;
      width = 2;
    };
  };

  hjem.users.leah.ext.programs.swayosd = {
    enable = true;
    settings.server.show_percentage = true;
    style = ./swayosd/style.css;
  };
}
