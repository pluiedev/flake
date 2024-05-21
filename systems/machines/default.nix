{ personal, personal-mac, ... }:
{
  nixosConfigurations = {
    tagliatelle.profile = personal;
    fettuccine.profile = personal;
  };
  darwinConfigurations = {
    fromage.profile = personal-mac;
  };
}
