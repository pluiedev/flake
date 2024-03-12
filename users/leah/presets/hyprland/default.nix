{pkgs, ...}: {
  imports = [
    ./waybar

    ./clipboard.nix
    ./greetd.nix
    ./mako.nix
    ./media.nix
    ./qt.nix
    ./screenshots.nix
    ./settings.nix
  ];

  roles.hyprland.enable = true;
  roles.dolphin.enable = true;

  # Apply GTK themes.
  # Some DEs, like Plasma, apply the GTK themes themselves and the configs
  # that HM generates would conflict with Plasma's, so let's only enable this
  # in environments that actually need manual application.
  hm.gtk.enable = true;

  hm.home.packages = with pkgs; [
    networkmanagerapplet # necessary for icons
  ];

  hm.programs = {
    kitty.enable = true;

    wpaperd.enable = true;

    fuzzel = {
      enable = true;
      settings.main = {
        font = "Iosevka Nerd Font:size=13";
        dpi-aware = true;
      };
    };
  };

  hm.services.blueman-applet.enable = true;

  services.gnome.gnome-keyring.enable = true;
  services.upower.enable = true;
}
