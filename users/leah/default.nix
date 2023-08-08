{pkgs, ...}: let
  user = {
    name = "leah";
    realName = "Leah";
    fullName = "Leah Amelia Chen";
    modules = [
      ./accounts.nix
      ./programs
    ];
  };
in {
  users.users.${user.name} = {
    isNormalUser = true;
    description = user.realName;
    extraGroups = [
      "networkmanager"
      "wheel" # `sudo` powers
    ];
    shell = pkgs.fish;
  };

  programs = {
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [user.name];
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };

    fish.enable = true;

    starship = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };
  };

  pluie.user = user;
}
