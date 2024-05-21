{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs = {
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      package = pkgs._1password-gui-beta;
      polkitPolicyOwners = lib.optional config.roles.base.canSudo config.roles.base.username;
    };
  };

  hm.programs._1password = {
    enable = true;

    # I *somehow* ended up with a local DB whose schema version is newer than stable...
    # Welp. Whatever, just use beta lmao
    package = pkgs._1password-gui-beta;

    autostart = true;

    sshAgent.enable = true;

    settings = {
      app.useHardwareAcceleration = true;
      advanced.EnableDebuggingTools = true;

      security = {
        # Use system auth (PolKit) to unlock 1Pass
        authenticatedUnlock.enabled = true;
        # Lock 1Pass on sleep/hibernate/lock/whatever
        autolock.onDeviceLock = true;
      };

      # Check vulnerable passwords
      privacy.checkHibp = true;

      # Integrate with 1Password CLI
      developers.cliSharedLockState.enabled = true;

      sshAgent = {
        # Ask approval for each new application.
        # (1Pass misspelled it, not me.)
        sshAuthorizatonModel = "application";
        # Display key names when authorizing connections
        storeKeyTitles = true;
        storeSshKeyTitlesResponseGiven = true;
        authPromptsV2.enabled = true;
      };

      # Scan disk for dev credentials
      devWatchtower.localDiskScanning = true;
    };
  };

  # Use the 1Password CLI plugins
  # TODO: no workey!
  #hm.home.sessionVariables = {
  #  OP_PLUGIN_ALIASES_SOURCED = "1";
  #  OP_BIOMETRIC_UNLOCK_UNABLED = "true";
  #};

  #hm.programs.fish.shellAliases = lib.pipe ["cargo" "gh"] [
  #  (map (name: {
  #    inherit name;
  #    value = "${lib.getExe' pkgs._1password "op"} plugin run -- ${name}";
  #  }))
  #  builtins.listToAttrs
  #];
}
