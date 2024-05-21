{ lib, ... }:
{
  imports = lib.pipe ./. [
    builtins.readDir
    (lib.filterAttrs (n: ty: ty == "directory" && builtins.pathExists ./${n}/default.nix))
    (lib.mapAttrsToList (n: _: ./${n}))
  ];
}
