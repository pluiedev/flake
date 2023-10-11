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

  services.postgresql = {
    enable = true;
    ensureDatabases = ["eats"];
    authentication = ''
      #type database  DBuser auth-method
      local all       all    trust
    '';
  };

  nixpkgs.overlays = [krunner-nix.overlays.default];
}
