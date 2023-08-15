{
  config,
  lib,
  ...
}: let
  cfg = config.pluie.desktop;
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  imports = [
    ./audio.nix
    ./fonts.nix
    ./plasma.nix
    ./wayland.nix
  ];

  options.pluie.desktop.enable = mkEnableOption "desktop module";

  config = mkIf cfg.enable {
    pluie.desktop = {
      audio.enable = mkDefault true;
      fonts.enable = mkDefault true;
      wayland.enable = mkDefault true;
    };

    programs.dconf.enable = true;
    services.xserver.enable = true;
    xdg.portal.enable = true;

    networking.networkmanager.enable = true;

    services.xserver = {
      layout = "us";
      xkbVariant = "";
    };

    # Printing
    services.printing.enable = true;
  };
}
