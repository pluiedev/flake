{lib, ...}: {
  options.roles.plasma = {
    enable = lib.mkEnableOption "Plasma";
    krunner-nix.enable = lib.mkEnableOption "krunner-nix, a KRunner plugin that suggests Nix programs to run";
  };
}
