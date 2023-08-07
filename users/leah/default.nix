_: let
  user = {
    name = "leah";
    realName = "Leah";
    fullName = "Leah Amelia Chen";
  };
in {
  imports = [
    ./shell.nix
  ];
  _module.args = {inherit user;};

  users.users.${user.name} = {
    isNormalUser = true;
    description = user.realName;
    extraGroups = [
      "networkmanager"
      "wheel" # `sudo` powers
    ];
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
  };

  home-manager.users.${user.name} = {
    imports = [./home.nix];
    _module.args = {inherit user;};
  };
}
