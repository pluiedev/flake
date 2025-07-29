# Common configs for all machines.
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ../users
  ];

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
    };
  };

  nixpkgs = {
    # I'm not part of the FSF and I don't care
    config.allowUnfree = true;
    flake.setNixPath = true;

    overlays = [ inputs.self.overlays.default ];
  };

  # Enable building and testing aarch64 packages for Nixpkgs dev
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.extra-platforms = [ "aarch64-linux" ];

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
    # This *should* be enough for most Electron apps
    ELECTRON_OZONE_PLATFORM_HINT = "auto";

    # Apply Nixpkgs-specific flags too
    NIXOS_OZONE_WL = "1";

    # Some SDL 2 apps are very naughty and don't work nicely under Wayland
    SDL_VIDEODRIVER = "x11";

    # SDL 3 should be able to use native Wayland just fine.
    SDL_VIDEO_DRIVER = "wayland";
  };

  services = {
    # Use dbus-broker for higher D-Bus performance
    dbus.implementation = "broker";

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

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  networking.networkmanager.enable = true;

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
