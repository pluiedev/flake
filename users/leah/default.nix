{
  config,
  pkgs,
  lib,
  plasma-manager,
  ...
}: let
  inherit (config.pluie) user;
in {
  pluie = {
    user = {
      name = "leah";
      realName = "Leah";
      fullName = "Leah Amelia Chen";
      canSudo = true;
      modules = [
        ./home.nix
        plasma-manager.homeManagerModules.plasma-manager
      ];

      settings.shell = pkgs.fish;
    };

    desktop._1password.enable = true;
  };

  programs.fish.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
}
