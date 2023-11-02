# NVIDIA? More like :novideo:
{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.roles.nvidia.enable = mkEnableOption "NVIDIA drivers";
}
