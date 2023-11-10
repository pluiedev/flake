inputs @ {lib, ...}: {
  imports =
    [./.]
    ++ (lib.pipe (import ./. inputs).imports [
      (map (s: /${s}/nixos.nix))
      (builtins.filter builtins.pathExists)
    ]);
}
