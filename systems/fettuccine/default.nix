{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    ../common.nix
    ./hardware-configuration.nix
    ../../users/leah

    common-hidpi
    asus-zephyrus-gu603h
  ];

  networking.hostName = "fettuccine";

  boot = {
    # Disable Nvidia's HDMI audio
    blacklistedKernelModules = [ "snd_hda_codec_hdmi" ];

    # FIXME: switch back to latest xanmod after 6.15.5
    kernelPackages = pkgs.linuxPackages_latest;
  };

  # Enable building and testing aarch64 packages for Nixpkgs dev
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.extra-platforms = [ "aarch64-linux" ];

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

  networking.firewall = {
    enable = true;

    # Allow previewing local Vite builds on other devices via LAN
    allowedTCPPorts = [ 5173 ];
  };

  specialisation.china.configuration = {
    # cache.nixos.org is *unbearably* slow when accessed from Mainland China.
    # Fortunately, mirror sites exist... Hooray(?)
    nix.settings.substituters = map (url: "${url}/nix-channels/store") [
      "https://mirrors.ustc.edu.cn"
      "https://mirrors6.tuna.tsinghua.edu.cn"
      "https://mirrors.tuna.tsinghua.edu.cn"
      # "https://mirror.sjtu.edu.cn" # FIXME: buggy?
    ];

    environment.sessionVariables.all_proxy = "http://127.0.0.1:2080";
  };
}
