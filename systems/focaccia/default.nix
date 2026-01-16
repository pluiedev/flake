{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.nixosConfigurations.focaccia = lib.nixosSystem {
    modules = [ ./configuration.nix ];
    specialArgs = { inherit inputs; };
  };

  flake.deploy.nodes.focaccia = {
    sshOpts = [
      "-p"
      "42069"
    ];
    hostname = "focaccia.pluie.me";
    profiles = {
      system = {
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.focaccia;
        user = "root";
        sshUser = "root";
      };
    };
  };
}
