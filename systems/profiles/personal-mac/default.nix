inputs @ {
  nix-darwin,
  home-manager,
  ...
}: name: {
  system = "x86_64-darwin";
  builder = nix-darwin.lib.darwinSystem;

  modules = [
    home-manager.darwinModules.home-manager

    ../../../roles/darwin.nix
    ../../../users/personal.nix

    {system.stateVersion = 4;}
  ];
  specialArgs = inputs;
}
