{user, ...}: {
  imports = [./programs];

  pluie.user = {
    email = let
      migadu = {
        imap = {
          host = "imap.migadu.com";
          port = 993;
        };
        smtp = {
          host = "smtp.migadu.com";
          port = 465;
        };
      };
    in {
      enable = true;
      accounts = {
        "hi@pluie.me" = {
          primary = true;
          realName = user.fullName;
          host = migadu;
        };
        "acc@pluie.me" = {
          realName = "${user.fullName} [accounts]";
          host = migadu;
        };
      };
    };

    locales.chinese.enable = true;
  };

  services.blueman-applet.enable = true;
}
