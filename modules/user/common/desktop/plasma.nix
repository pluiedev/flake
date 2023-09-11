{plasma-manager, ...}: {
  imports = [
    plasma-manager.homeManagerModules.plasma-manager
  ];

  programs.plasma.enable = true;
}
