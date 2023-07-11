{
  inputs,
  self,
  flake-utils,
  nixpkgs,
  ...
}:

#flake-utils.lib.eachDefaultSystem (system:
let
  hook = inputs.pre-commit-hooks.lib."x86_64-linux".run {
    src = self;
    hooks = {
      alejandra.enable = true;
      deadnix.enable = true;
      nil.enable = true;
      statix.enable = true;
      stylua.enable = true;
    };
  };
in
  {
    checks.pre-commit-check = hook;

    devShell = nixpkgs.legacyPackages."x86_64-linux".mkShell {
      inherit (hook) shellHook;
    };
  }

#)
