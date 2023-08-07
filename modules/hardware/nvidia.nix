# NVIDIA? More like :novideo:
{
  config,
  lib,
  ...
}: let
  cfg = config.pluie.hardware.nvidia;
  inherit (lib) mkIf mkEnableOption;
in {
  options.pluie.hardware.nvidia.enable = mkEnableOption "NVIDIA drivers";

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = ["nvidia"];

    hardware = {
      opengl = {
        enable = true;
        driSupport32Bit = true; # Steam apparently requires this to work
      };
      # Modesetting is needed for most Wayland compositors
      nvidia.modesetting.enable = true;
    };
  };
}
