{pkgs, ...}: let
  user = rec {
    name = "leah";
    realName = "Leah";
    fullName = "Leah Amelia Chen";
    modules = [
      ./programs
    ];
    email = {
      enable = true;

      host = {
        imap = {
          host = "imap.migadu.com";
          port = 993;
        };
        smtp = {
          host = "smtp.migadu.com";
          port = 465;
        };
      };
      accounts = {
        "hi@pluie.me" = {
          primary = true;
          realName = fullName;
          _1passItemId = "fjutji565zipohkgsowe3c3nqq";
        };
        "acc@pluie.me" = {
          realName = "${fullName} [accounts]";
          _1passItemId = "s6b5a7cf236jmpthkbdc4yzacu";
        };
      };
    };
  };
in {
  pluie = {
    inherit user;
    tools.rust.enable = true;
  };

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
}
