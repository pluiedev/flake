{ pkgs, ... }:
{
  imports = [
    ./sddm.nix
    ./settings
  ];

  boot.plymouth.enable = true;
  roles.plasma = {
    enable = true;
    krunner-nix.enable = true;
  };

  # KDE manages GTK stuff by itself
  #hm.gtk.enable = lib.mkForce false;

  hm.home.packages = with pkgs; [
    wl-clipboard
  ];
}
