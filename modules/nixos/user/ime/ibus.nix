{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.pluie.user.ime;
  inherit (lib) mkIf;
in {
  config = mkIf (cfg.enabled == "ibus") {
    i18n.inputMethod.ibus.engines = map (x: pkgs.ibus-engines.${x}) cfg.engines;
  };
}
