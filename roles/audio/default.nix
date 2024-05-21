{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.roles.audio.enable = mkEnableOption "audio support" // {
    default = true;
  };
}
