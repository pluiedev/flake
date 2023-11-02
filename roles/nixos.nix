{lib, ...}: {
  imports =
    [
      ./common.nix
    ]
    ++ lib.pipe ((import ./common.nix).imports) [
      (map (s: /${s}/nixos.nix))
      (builtins.filter builtins.pathExists)
    ];
}
