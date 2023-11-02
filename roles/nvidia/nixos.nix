{
  config,
  lib,
  ...
}: let
  cfg = config.roles.plasma;
  inherit (lib) mkIf;
in {
  config = mkIf cfg.enable {
    hardware = {
      opengl = {
        enable = true;
        driSupport32Bit = true; # Steam apparently requires this to work
      };
      nvidia = {
        # Modesetting is needed for most Wayland compositors
        modesetting.enable = true;

        powerManagement = {
          enable = true;
          finegrained = true;
        };
      };
    };
    services.xserver = {
      enable = true;
      videoDrivers = ["nvidia"];
    };
  };
}
