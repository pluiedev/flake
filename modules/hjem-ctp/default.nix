# Catppuccin theming
{
  config,
  lib,
  ...
}:
let
  ctp-lib = import ./_lib.nix { inherit config lib; };

  global.options.ctp = ctp-lib.mkCatppuccinOptions "Global" {
    inheritFrom = { };
    withAccent = true;
  };
in
{
  imports = [
    global

    ./fcitx5.nix
    ./fish.nix
    ./fuzzel.nix
    # ./plasma.nix
    ./vencord.nix
    ./wleave.nix
  ];

  _module.args = { inherit ctp-lib; };
}
