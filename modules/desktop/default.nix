{
  config,
  lib,
  ...
}: let
  cfg = config.pluie.desktop;
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  imports = [
    ./1password.nix
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

    pluie.user.config.xdg.enable = true;
    xdg.portal.enable = true;

    networking.networkmanager.enable = true;
    users.users.${config.pluie.user.name}.extraGroups = ["networkmanager"];

    services.zerotierone.enable = true;

    services.xserver = {
      layout = "us";
      xkbVariant = "";
    };

    # Printing
    services.printing.enable = true;
  };
}
