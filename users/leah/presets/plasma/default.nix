{
  config,
  krunner-nix,
  pkgs,
  ...
}: {
  imports = [
    ./fusuma.nix
    ./sddm.nix
    ./settings.nix
  ];

  boot.plymouth.enable = true;
  roles.plasma.enable = true;
  roles.qt.platform = "kde";

  hm.gtk.gtk2.configLocation = "${config.hm.xdg.configHome}/gtk-2.0/gtkrc";

  hm.home.packages = [krunner-nix.packages.${pkgs.system}.default];
}
