# Laptop configuration for when I'm on the move
{
  pkgs,
  ...
}:
{
  imports = [
    ./common.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  # Update the system timezone according to physical location
  systemd.services.automatic-timezoned.enable = true;

  specialisation.china.configuration = {
    # cache.nixos.org is *unbearably* slow when accessed from Mainland China.
    # Fortunately, mirror sites exist... Hooray(?)
    nix.settings.substituters = map (url: "${url}/nix-channels/store") [
      "https://mirrors.ustc.edu.cn"
      "https://mirrors6.tuna.tsinghua.edu.cn"
      "https://mirrors.tuna.tsinghua.edu.cn"
      # "https://mirror.sjtu.edu.cn" # FIXME: buggy?
    ];

    # Redirect all traffic through proxy
    networking.proxy.allProxy = "http://127.0.0.1:2080";
    nix.settings.impure-env = [ "all_proxy=http://127.0.0.1:2080" ];

    # Make the auto upgrade mechanism upgrade to the correct specialization
    # so that proxies don't just randomly break the next day
    system.autoUpgrade.flags = [
      "--specialisation"
      "china"
    ];
  };
}
