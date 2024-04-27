{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  imports = [./lanzaboote];

  options.roles.boot = {
    enable = mkEnableOption "boot settings" // {default = true;};

    patch.fix-246195.enable = mkEnableOption "patch for Nixpkgs issue #246195" // {default = true;};
  };
}
