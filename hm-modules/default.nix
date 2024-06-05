{ flake-parts-lib, inputs, ... }:
let
  inherit (flake-parts-lib) importApply;
in
{
  flake.hmModules = {
    ctp-plus = importApply ./ctp-plus { inherit inputs; };
    hm-plus = ./hm-plus;
  };
}
