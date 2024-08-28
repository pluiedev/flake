{ pkgs, ... }:
{
  services.nix-daemon.enable = true;

  programs.fish.enable = true;
}
