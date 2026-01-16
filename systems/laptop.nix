# Laptop configuration for when I'm on the move
{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./common.nix
    ../users
  ];

  # Enable building and testing aarch64 packages for Nixpkgs dev
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.extra-platforms = [ "aarch64-linux" ];

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod;

    loader = {
      limine = {
        enable = true;
        maxGenerations = 10;
        enrollConfig = true;
        secureBoot.enable = true;
      };
      efi.canTouchEfiVariables = true;
    };

    # Silence NixOS Stage 1 logs, jump straight into plymouth
    consoleLogLevel = 0;
    initrd = {
      verbose = false;
      systemd.enable = true;
    };
    plymouth.enable = true;
    kernelParams = [
      "quiet"
      "plymouth.use-simpledrm"
      "i915.fastboot=1"
    ];
  };

  services = {
    # Some things sadly don't like being in Nixpkgs
    flatpak.enable = true;

    # Makes sure auto-mounting disks still work when not using a
    # traditional desktop environment like GNOME or KDE
    udisks2.enable = true;

    # Dynamically adjust performance settings based on load
    # instead of power-profile-daemon's rigid profiles
    tlp.enable = true;

    # Nobody likes PulseAudio in this household
    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      pulse.enable = true;

      # Some weird apps still talk to ALSA directly
      alsa.enable = true;

      # JACK should only be necessary for some professional audio
      # software (e.g. DAWs like Ardour or video editing software
      # like DaVinci Resolve), but we enable it no matter what
      jack.enable = true;
    };
  };

  # Real-time audio software like DAWs are
  # *crippled* without rtkit
  security.rtkit.enable = true;

  # Use native Wayland when possible
  environment.variables = {
    # This *should* be enough for most Electron apps
    ELECTRON_OZONE_PLATFORM_HINT = "auto";

    # Apply Nixpkgs-specific flags too
    NIXOS_OZONE_WL = "1";

    # Some SDL 2 apps are very naughty and don't work nicely under Wayland
    SDL_VIDEODRIVER = "x11";

    # SDL 3 should be able to use native Wayland just fine.
    SDL_VIDEO_DRIVER = "wayland";
  };

  networking.networkmanager.enable = true;

  # Allow GPU usage monitoring utilities like `intel_gpu_top`
  # to function without superuser access
  boot.kernel.sysctl."kernel.perf_event_paranoid" = 0;

  # Update the system timezone according to physical location
  systemd.services.automatic-timezoned.enable = true;

  # Show a pretty diff
  system = {
    # Thank @luishfonseca for this
    # https://github.com/luishfonseca/dotfiles/blob/ab7625ec406b48493eda701911ad1cd017ce5bc1/modules/upgrade-diff.nix
    activationScripts.diff = {
      supportsDryActivation = true;
      text = ''
        ${lib.getExe pkgs.nvd} --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
      '';
    };
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

    # Redirect all traffic through proxy
    networking.proxy.allProxy = "http://127.0.0.1:2080";
    nix.settings.impure-env = [
      "all_proxy=http://127.0.0.1:2080"
      "GOPROXY=https://goproxy.cn"
    ];

    # Make the auto upgrade mechanism upgrade to the correct specialization
    # so that proxies don't just randomly break the next day
    system.autoUpgrade.flags = [
      "--specialisation"
      "china"
    ];
  };
}
