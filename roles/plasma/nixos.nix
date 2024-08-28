{
  config,
  lib,
  pkgs,
  inputs,
  inputs',
  ...
}:
let
  cfg = config.roles.plasma;
  inherit (lib) mkIf;
in
{
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

    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-kde ];
    roles.qt.platform = "kde";

    hm = {
      imports = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];

      home.packages = lib.optional cfg.krunner-nix.enable inputs'.krunner-nix.packages.default;

      # Janky workaround
      # https://github.com/nix-community/home-manager/issues/1586
      programs.firefox.package = pkgs.firefox.override {
        cfg.nativeMessagingHosts.packages = [ pkgs.plasma6Packages.plasma-browser-integration ];
      };

      programs.plasma.enable = true;
    };
  };
}
