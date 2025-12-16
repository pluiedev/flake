{
  pkgs,
  ...
}:
{
  imports = [
    ./gui-toolkits.nix
    ./services.nix
    ./waybar
    ./swaync
    ./swayosd
  ];

  programs.niri.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  hjem.users.leah = {
    packages = with pkgs; [
      networkmanagerapplet
      xwayland-satellite
      brightnessctl
      wleave

      # Desktop utilities
      file-roller
      loupe
      gnome-logs
      resources
      # I'm using Nautilus here because it a) looks nice
      # and b) avoids configuring XDP GNOME to use a XDP GTK's file chooser
      nautilus
    ];

    xdg.config.files."niri/config.kdl".source = ./config.kdl;

    ext.programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;

      settings = {
        show-failed-attempts = true;
        ignore-empty-password = true;
        daemonize = true;

        screenshots = true;
        scaling = "fit";
        clock = true;
        indicator-idle-visible = true;
        grace = 3;
        effect-blur = "10x10";
        effect-vignette = "0.5:0.8";
        effect-pixelate = 4;

        text-color = "#cdd6f4";
        inside-color = "#181825";
        inside-clear-color = "#a6e3a1";
        inside-ver-color = "#cba6f7";
        inside-wrong-color = "#f38ba8";
        ring-color = "#1e1e2e";
        ring-clear-color = "#a6e3a1";
        ring-ver-color = "#cba6f7";
        ring-wrong-color = "#f38ba8";
        key-hl-color = "#eba0ac";
        bs-hl-color = "#6c7086";
        line-color = "#313244";

        timestr = "%H:%M";
        datestr = "%e %b '%y / %a";
      };
    };

    ext.programs.vicinae = {
      enable = true;
      settings = {
        closeOnFocusLoss = false;
        considerPreedit = true;
        font.size = 12;
        keybinding = "default";
        popToRootOnClose = true;
        window = {
          csd = true;
          opacity = 0.85;
          rounding = 16;
        };
      };
    };
  };
}
