{ inputs, ... }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  args' = {
    inherit config pkgs inputs;
    lib = import "${inputs.catppuccin}/modules/lib/mk-ext-lib.nix" { inherit config lib pkgs; };
  };
in
{
  imports = map (p: import p args') [
    ./konsole.nix
    ./plasma.nix
    ./vencord.nix
  ];
}
