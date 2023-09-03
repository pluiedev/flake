{pkgs, ...}: {
  services.nix-daemon.enable = true;

  programs.fish.enable = true;

  system.stateVersion = 4;

  nixpkgs.hostPlatform = "x86_64-darwin";
}
