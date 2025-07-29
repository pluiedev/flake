{
  config,
  lib,
  inputs,
  ...
}:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    ../common.nix
    ./hardware-configuration.nix
    asus-zephyrus-gu603h
  ];

  networking.hostName = "fettuccine";

  users.users.leah.enable = true;

  # Disable Nvidia's HDMI audio
  boot.blacklistedKernelModules = [ "snd_hda_codec_hdmi" ];

  # Allow CUDA
  nixpkgs.config.cudaSupport = true;

  hardware = {
    bluetooth.enable = true;

    nvidia = {
      # PCI bus IDs are already conveniently set by nixos-hardware
      prime.offload.enable = lib.mkForce true;

      # Beta can sometimes be more stable than, well, stable
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };

  # Nix can sometimes overload my poor, poor laptop CPU
  # so much that it can freeze my entire system. Amazing.
  # Please don't do that.
  nix.daemonCPUSchedPolicy = "idle";

  # This is an ASUS computer after all
  services.asusd.enable = true;
}
