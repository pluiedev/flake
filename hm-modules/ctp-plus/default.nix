{ inputs, ... }:
{
  config,
  lib,
  pkgs,
  ...
}@args:
let
  args' = args // {
    inherit inputs;
    ctpLib = import "${inputs.catppuccin}/modules/lib" { inherit config lib pkgs; };
  };
in
{
  imports = map (p: import p args') [
    ./plasma.nix
    ./vencord.nix
  ];
}
