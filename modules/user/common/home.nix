{user, ...}: {
  imports =
    [
      ./desktop
      ./email.nix
      ./locales
      ./tools
    ]
    ++ user.modules;

  home = {
    inherit (user) homeDirectory;
    username = user.name;
    stateVersion = "23.05";
  };

  programs.home-manager.enable = true;
  xdg.enable = true;
}
