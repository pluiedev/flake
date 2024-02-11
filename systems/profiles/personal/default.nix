inputs @ {
  nixpkgs,
  home-manager,
  ...
}: name: {
  system = "x86_64-linux";
  builder = nixpkgs.lib.nixosSystem;

  modules = [
    home-manager.nixosModules.home-manager

    ../../../roles/nixos.nix
    ../../../users/personal.nix

    {system.stateVersion = "24.05";}
  ];
  specialArgs = inputs;
}
