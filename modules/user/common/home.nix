{user, ...}: {
  imports =
    [
      ./desktop
      ./email.nix
      ./locales
      ./tools
    ]
    ++ user.modules;
  _module.args = {inherit user;};

  home.username = user.name;
  home.homeDirectory = user.homeDirectory;
  home.stateVersion = "23.05";

  programs.home-manager.enable = true;
  xdg.enable = true;
}
