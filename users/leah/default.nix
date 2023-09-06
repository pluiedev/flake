{
  config,
  pkgs,
  lib,
  ...
}: let
  user = config.pluie.user;
in {
  pluie = {
    user = {
      name = "leah";
      realName = "Leah";
      fullName = "Leah Amelia Chen";
      canSudo = true;
      modules = [./programs];
    };

    desktop._1password.enable = true;
  };

  programs.fish.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
}
