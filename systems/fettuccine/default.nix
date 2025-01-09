{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    ./hardware-configuration.nix

    common-hidpi
    asus-zephyrus-gu603h
  ];

  roles = {
    # boot.lanzaboote.enable = true;
    # nvidia.enable = true;
  };

  hardware.bluetooth.enable = true;

  # Other Nvidia settings are set via nixos-hardware
  #hardware.nvidia.dynamicBoost.enable = true;

  hardware.nvidia.prime.offload.enable = lib.mkForce true;
  # hardware.nvidia.prime.sync.enable = true;

  # Disable Nvidia's HDMI audio
  boot.blacklistedKernelModules = [ "snd_hda_codec_hdmi" ];

  services.asusd.enable = true;

  specialisation.china.configuration = {
    roles.mirrors.chinese.enable = true;
    environment.variables.NIXOS_SPECIALISATION = "china";

    environment.systemPackages = [ pkgs.nekoray ];

    nix.settings = {
      experimental-features = [ "configurable-impure-env" ];
      impure-env = [ "all_proxy=http://127.0.0.1:2080" ];
    };
  };
}
