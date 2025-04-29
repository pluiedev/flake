{
  config,
  pkgs,
  lib,
  ...
}:
let
  # Helper script for running Steam games with
  # a *reasonable* preset
  steam-assist =
    lib.optionalString config.hardware.nvidia.prime.offload.enable ''
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
    '' + ''
      ${lib.getExe' pkgs.gamemode "gamemoderun"} $@
    '';
in
{
  programs.gamemode.enable = true;

  programs.steam = {
    enable = true;

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

  hjem.users.leah.packages = [
    (pkgs.writeShellScriptBin "steam-assist" steam-assist)
  ];
}
