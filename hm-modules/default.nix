{ flake-parts-lib, moduleWithSystem, inputs, ... }:
let
  inherit (flake-parts-lib) importApply;
in
{
  flake.hmModules = {
    ctp-plus = importApply ./ctp-plus { inherit inputs; };
    hm-plus = moduleWithSystem (import ./hm-plus);
  };
}
