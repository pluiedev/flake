{
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

  hm.home.packages = [krunner-nix.packages.${pkgs.system}.default];
}
