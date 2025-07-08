{
  pkgs,
  inputs,
  ...
}:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    ../common.nix
    ./hardware-configuration.nix
    ../../users/leah

    lenovo-ideapad-14iah10
  ];

  hardware.bluetooth.enable = true;

  networking.hostName = "pappardelle";

  boot = {
    # FIXME: switch back to latest xanmod after 6.15.5
    kernelPackages = pkgs.linuxPackages_latest;
  };

  # Enable building and testing aarch64 packages for Nixpkgs dev
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.extra-platforms = [ "aarch64-linux" ];

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

    networking.proxy.allProxy = "http://127.0.0.1:2080";
  };
}
