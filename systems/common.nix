# Common configs for all machines.
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  system.stateVersion = "25.05";

  nix = {
    # Add `n` as an alias of `nixpkgs`
    registry.n.to = {
      type = "path";
      path = config.nixpkgs.flake.source;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
        "auto-allocate-uids"
        "configurable-impure-env"
      ];
      trusted-users = [ "@wheel" ];
      impure-env = [ "all_proxy=http://127.0.0.1:2080" ];
    };
  };

  nixpkgs = {
    # I'm not part of the FSF and I don't care
    config.allowUnfree = true;
    flake.setNixPath = true;

    overlays = [ inputs.self.overlays.default ];
  };

  boot = {
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

    tmp.useTmpfs = true;
  };

  # Make Nix use /var/tmp for building, so that
  # large files don't have to live in tmpfs
  systemd.services.nix-daemon.environment.TMPDIR = "/var/tmp";

  # Use native Wayland when possible
  environment.variables = {
    NIXOS_OZONE_WL = "1";

    # Some SDL 2 apps are very naughty and don't work nicely under Wayland
    SDL_VIDEODRIVER = "x11";

    # SDL 3 should be able to use native Wayland just fine.
    SDL_VIDEO_DRIVER = "wayland";
  };

  services = {
    dbus.implementation = "broker";
    flatpak.enable = true;
    udisks2.enable = true;
    tlp.enable = true;

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
    };
  };

  security.rtkit.enable = true;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  networking.networkmanager = {
    enable = true;
  };

  system = {
    # Thank @luishfonseca for this
    # https://github.com/luishfonseca/dotfiles/blob/ab7625ec406b48493eda701911ad1cd017ce5bc1/modules/upgrade-diff.nix
    activationScripts.diff = {
      supportsDryActivation = true;
      text = ''
        ${lib.getExe pkgs.nvd} --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
      '';
    };

    # thanks to @getchoo
    autoUpgrade = {
      enable = true;
      flake = "git+https://tangled.sh/@pluie.me/flake#${config.networking.hostName}";
      flags = [ "--refresh" ];
    };

    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or "unknown-dirty";
  };
}
