{
  self,
  inputs,
  ...
}: {
  flake = let
    inherit (inputs.nixpkgs) lib;
    inherit (import ./profiles/lib.nix) mkSystems;

    profiles = import ./profiles inputs;
    machines = import ./machines profiles;
  in
    builtins.mapAttrs (_: mkSystems) machines
    // {
      hydraJobs = let
        ciSystems = ["x86_64-linux"];
        mapCfgsToDerivs = lib.mapAttrs (_: cfg: cfg.activationPackage or cfg.config.system.build.toplevel);
        getCompatibleCfgs = lib.filterAttrs (_: cfg: lib.elem cfg.pkgs.system ciSystems);
      in {
        nixosConfigurations = mapCfgsToDerivs (getCompatibleCfgs self.nixosConfigurations);
      };
    };
}
