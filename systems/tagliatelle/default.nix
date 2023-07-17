# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  nixpkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Shanghai";

  # X configs
  services.xserver = {
    enable = true;

    # We use KDE in this household
    desktopManager.plasma5.enable = true;
    displayManager.sddm.enable = true;

    # NVIDIA? More like :novideo:
    videoDrivers = ["nvidia"];
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true; # Steam apparently requires this to work
    };
    nvidia = {
      # Modesetting is needed for most Wayland compositors
      modesetting.enable = true;
    };
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Printing
  services.printing.enable = true;

  # Audio
  sound.enable = true;
  hardware.pulseaudio.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  environment.systemPackages = with pkgs; [
    git
    gcc
  ];
}
