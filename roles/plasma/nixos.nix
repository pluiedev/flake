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
    services.xserver.desktopManager.plasma5 = {
      enable = true;
      useQtScaling = true;
    };

    # Hibernate fix
    boot.extraModprobeConfig = ''
      options nvidia NVreg_PreserveVideoMemoryAllocations=1 NVreg_TemporaryFilePath=/var/tmp
    '';

    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-kde];

    hm = {
      imports = [plasma-manager.homeManagerModules.plasma-manager];

      home.packages = lib.optional cfg.krunner-nix.enable pkgs.krunner-nix;

      # Janky workaround
      # https://github.com/nix-community/home-manager/issues/1586
      programs.firefox.package = pkgs.firefox.override {
        cfg.nativeMessagingHosts.packages = [pkgs.plasma5Packages.plasma-browser-integration];
      };

      programs.plasma.enable = true;
    };

    nixpkgs.overlays = lib.optional cfg.krunner-nix.enable krunner-nix.overlays.default;
  };
}
