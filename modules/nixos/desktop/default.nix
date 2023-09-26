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
    xdg.portal.enable = true;

    networking.networkmanager.enable = true;
    users.users.${config.pluie.user.name}.extraGroups = ["networkmanager"];

    services = {
      zerotierone.enable = true;

      xserver = {
        enable = true;
        layout = "us";
        xkbVariant = "";
      };

      printing.enable = true;
    };
  };
}
