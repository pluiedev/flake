{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.roles.networking = {
    enable = mkEnableOption "Networking" // {default = true;};
  };
}
