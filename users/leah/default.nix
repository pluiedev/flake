_: {
  pluie = {
    user = rec {
      name = "leah";
      realName = "Leah";
      fullName = "Leah Amelia Chen";
      modules = [./programs];
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
          };
          "acc@pluie.me".realName = "${fullName} [accounts]";
        };
      };
    };

    desktop._1password.enable = true;
    tools = {
      fish.enable = true;
      rust.enable = true;
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
}
