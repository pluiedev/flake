{
  config,
  self,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.hjem.nixosModules.hjem
  ];

  hjem.extraModules = [
    inputs.hjem-rum.hjemModules.default
    self.hjemModules.hjem-ext
  ];

  system.stateVersion = "24.11";

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

    overlays = [ self.overlays.default ];
  };

  boot = {
    loader = {
      limine = {
        enable = true;
        maxGenerations = 10;

        style.wallpapers = [ ];

        style.graphicalTerminal = {
          palette = "1e1e2e;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4";
          brightPalette = "585b70;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4";
          background = "1e1e2e";
          foreground = "cdd6f4";
          brightBackground = "585b70";
          brightForeground = "cdd6f4";

          font.scale = "2x2";
        };
      };
      efi.canTouchEfiVariables = true;
    };

    # Silence NixOS Stage 1 logs, jump straight into plymouth
    consoleLogLevel = 0;
    initrd.verbose = false;
    plymouth.enable = true;
    kernelParams = [
      "quiet"
      "splash"
      "plymouth.use-simpledrm"
      "i915.fastboot=1"
    ];
  };

  # Use native Wayland when possible
  environment.variables = {
    NIXOS_OZONE_WL = "1";
    SDL_VIDEODRIVER = "wayland,x11";
  };

  services = {
    flatpak.enable = true;

    desktopManager.plasma6.enable = true;
    displayManager = {
      defaultSession = "plasma";
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };

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
      flake = "github:pluiedev/flake#${config.networking.hostName}";
      flags = [ "--refresh" ];
    };

    configurationRevision = self.rev or self.dirtyRev or "unknown-dirty";
  };
}
