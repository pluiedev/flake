# Common configs for all machines.
{
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-generators.nixosModules.all-formats
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

  boot.tmp = {
    cleanOnBoot = true;
    useTmpfs = true;
  };

  # Make Nix use /var/tmp for building, so that
  # large files don't have to live in tmpfs
  systemd.services.nix-daemon.environment.TMPDIR = "/var/tmp";

  # Use dbus-broker for higher D-Bus performance
  services.dbus.implementation = "broker";

  # This is very bizarre.
  # 
  # Within the Tangled CI environment there's no user information at all,
  # and the builder is ran with ID 0. This is a problem because logrotate's
  # check script apparently assumes the `id` binary will always succeed.
  # Given that I don't want to mess with logrotate at all beyond what is
  # already given to me as a default, I think it's saner to just disable
  # config validation to make CI pass.
  services.logrotate.checkConfig = false;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or "unknown-dirty";
}
