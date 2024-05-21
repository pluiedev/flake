inputs@{ lib, ... }:
{
  imports =
    [ ./. ]
    ++ (lib.pipe (import ./. inputs).imports [
      (map (s: /${s}/darwin.nix))
      (builtins.filter builtins.pathExists)
    ]);
}
