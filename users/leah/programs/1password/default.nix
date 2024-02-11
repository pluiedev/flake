{
  # TODO: horrendously broken
  # hm = {
  # Use the 1Password CLI plugins
  #   home.sessionVariables.OP_PLUGIN_ALIASES_SOURCED = "1";
  #
  #   programs.fish.shellAliases = {
  #     cargo = "op plugin run -- cargo";
  #     gh = "op plugin run -- gh";
  #   };
  # };

  roles._1password = {
    enable = true;
    autostart = true;

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
        enabled = true;
        # Ask approval for each new application.
        # (1Pass misspelled it, not me.)
        sshAuthorizatonModel = "application";
        # Display key names when authorizing connections
        storeKeyTitles = true;
        storeSshKeyTitlesResponseGiven = true;
        # FIXME: Rich prompts are currently broken on Nix! See nixpkgs#258139
        authPromptsV2.enabled = false;
      };
    };
  };
}
