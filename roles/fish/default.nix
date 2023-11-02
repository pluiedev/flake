{lib, ...}: {
  options.roles.fish = {
    enable = lib.mkEnableOption "Fish shell";
    defaultShell = lib.mkEnableOption "Fish shell as the user's default shell";
  };
}
