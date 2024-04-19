{
  services.displayManager.sddm = {
    enable = true;
    # TODO: use ibus if ibus is enabled, or fallback to compose, NEVER use virtual keyboard
    settings.General.InputMethod = "compose";

    catppuccin.enable = false; # awaiting port
  };
}
