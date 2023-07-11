{
  inputs,
  self,
  ...
}: {
  perSystem = {
    #pkgs,
    system,
    ...
  }: let
    hook = inputs.pre-commit-hooks.lib.${system}.run {
      src = self;
      hooks = {
        alejandra.enable = true;
        deadnix.enable = true;
        nil.enable = true;
        statix.enable = true;
        stylua.enable = true;
      };
    };
  in {
    checks.pre-commit-check = hook;
  
    #devShell = pkgs.mkShell {
    #  inherit (hook) shellHook;
    #};
  };
}
#flake-utils.lib.eachDefaultSystem (system:

#)

