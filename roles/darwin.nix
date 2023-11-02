{lib, ...}: {
  imports =
    [
      ./common.nix
    ]
    ++ lib.pipe ((import ./common.nix).imports) [
      (map (s: ./${s}/darwin.nix))
      (builtins.filter builtins.pathExists)
    ];
}
