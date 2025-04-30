{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.gamemode.enable = true;

  programs.steam = {
    enable = true;

    package = pkgs.steam.override {
      extraEnv = lib.optionalAttrs config.hardware.nvidia.prime.offload.enable {
        __NV_PRIME_RENDER_OFFLOAD = 1;
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      };
    };

    # Install Proton GE by default
    extraCompatPackages = [ pkgs.proton-ge-bin ];

    # Some native Linux games *assume* the distro has
    # certain packages that may not be present on NixOS.
    extraPackages = [
      pkgs.ncurses6 # Crusader Kings III
    ];

    protontricks.enable = true;
    remotePlay.openFirewall = true;
  };
}
