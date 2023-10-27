{
  pkgs,
  plasma-manager,
  krunner-nix,
  ...
}: {
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
  programs.nix-ld.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    enableNvidiaPatches = true;
  };

  services.blueman.enable = true;

  nixpkgs.overlays = [krunner-nix.overlays.default];
}
