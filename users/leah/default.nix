{
  pkgs,
  lib,
  ...
}: {
  pluie = rec {
    user = {
      name = "leah";
      realName = "Leah";
      fullName = "Leah Amelia Chen";
      canSudo = true;
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
            realName = user.fullName;
          };
          "acc@pluie.me".realName = "${user.fullName} [accounts]";
        };
      };
    };

    desktop._1password.enable = true;
    tools = {
      fish.enable = true;
      rust = {
        enable = true;
        settings = {
          build.rustc-wrapper = "${lib.getExe pkgs.sccache}";
          build.target-dir = "/home/${user.name}/.cargo/target";
        };
      };
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
}
