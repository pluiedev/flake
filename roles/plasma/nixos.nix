{
  config,
  lib,
  pkgs,
  plasma-manager,
  krunner-nix,
  ...
}: let
  cfg = config.roles.plasma;
  inherit (lib) mkIf;
in {
  config = mkIf cfg.enable {
    services = {
      desktopManager.plasma6.enable = true;
      displayManager = {
        defaultSession = "plasma";
        sddm = {
          enable = true;
          wayland.enable = true;
        };
      };
    };

    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-kde];
    roles.qt.platform = "kde";

    hm = {
      imports = [plasma-manager.homeManagerModules.plasma-manager];

      home.packages = lib.optional cfg.krunner-nix.enable krunner-nix.packages.${pkgs.system}.default;

      # Janky workaround
      # https://github.com/nix-community/home-manager/issues/1586
      programs.firefox.package = pkgs.firefox.override {
        cfg.nativeMessagingHosts.packages = [pkgs.plasma6Packages.plasma-browser-integration];
      };

      programs.plasma.enable = true;
    };
  };
}
