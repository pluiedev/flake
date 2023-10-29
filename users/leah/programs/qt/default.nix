{pkgs, ...}: {
  # TODO: also see default.nix for qt stuff. yay
  home.packages = [pkgs.catppuccin-qtct];

  xdg.configFile = let
    src = ./qtct.conf;
    themePath = "${pkgs.catppuccin-qtct}/share/qt5ct/colors/Catppuccin-Mocha.conf";
  in {
    "qt5ct/qt5ct.conf".source = pkgs.substituteAll {
      inherit src themePath;
      style = "Breeze";
    };
    "qt6ct/qt6ct.conf".source = pkgs.substituteAll {
      inherit src themePath;
      style = "Fusion";
    };
  };
}
