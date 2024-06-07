{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  imports = [ ./lanzaboote ];

  options.roles.boot = {
    enable = mkEnableOption "boot settings" // {
      default = true;
    };
  };
}
