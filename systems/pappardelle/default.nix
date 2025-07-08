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

    # nixos-hardware does not yet have a specific configuration
    # for the XiaoXin Pro 14 GT (= IdeaPad Slim 14, model 14IAH10),
    # but it's very easy to cobble together what upstream has provided
    common-cpu-intel
    common-pc-laptop
    common-pc-laptop-ssd
  ];

  # Specific to Meteor Lake and above
  hardware.intelgpu.vaapiDriver = "intel-media-driver";

  hardware.bluetooth.enable = true;

  networking.hostName = "pappardelle";

  boot = {
    # FIXME: switch back to latest xanmod after 6.15.5
    kernelPackages = pkgs.linuxPackages_latest;

    # DSP-based SOF drivers currently don't work due to missing topology
    # definitions, so we fall back to old snd_hda_intel drivers
    extraModprobeConfig = ''
      options snd-intel-dspcfg dsp_driver=1
    '';

    # HACK HACK HACK: Disable PCIe Power Management to completely disallow
    # the Wi-Fi adapter from turning off. This will be problematic for
    # performance, but at least I would have working Wi-Fi after waking up
    # from a suspend.
    kernelParams = [ "pcie_port_pm=off" ];
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
