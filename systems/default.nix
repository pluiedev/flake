{
  self,
  inputs,
  ...
}: {
  flake = let
    inherit (inputs.nixpkgs) lib;
    inherit (import ./profiles.nix inputs) mkSystems personal personal-mac;
  in {
    nixosConfigurations = mkSystems {
      tagliatelle.profile = personal;
      fettuccine.profile = personal;
    };
    darwinConfigurations = mkSystems {
      fromage.profile = personal-mac;
    };

    hydraJobs = let
      ciSystems = ["x86_64-linux"];
      mapCfgsToDerivs = lib.mapAttrs (_: cfg: cfg.activationPackage or cfg.config.system.build.toplevel);
      getCompatibleCfgs = lib.filterAttrs (_: cfg: lib.elem cfg.pkgs.system ciSystems);
    in {
      nixosConfigurations = mapCfgsToDerivs (getCompatibleCfgs self.nixosConfigurations);
    };
  };
}
