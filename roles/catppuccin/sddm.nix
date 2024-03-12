{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.roles.catppuccin) enable flavour;
  cfg = config.services.xserver.displayManager.sddm.catppuccin;
in {
  options.services.xserver.displayManager.sddm.catppuccin.enable = mkEnableOption "Catppuccin theme" // {default = enable;};

  config = mkIf (cfg.enable) {
    environment.systemPackages = pkgs.catppuccin-sddm.override {
      flavors = [flavour];
    };

    services.xserver.displayManager.sddm.theme = "catppuccin-${flavour}";
  };
}
