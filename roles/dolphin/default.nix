{lib, ...}: {
  options.roles.dolphin = {
    enable = lib.mkEnableOption "Dolphin file manager";
  };
}
