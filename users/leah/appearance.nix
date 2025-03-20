{
  self,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  flavor = "mocha";
  accent = "maroon";
in
{
  imports = [ inputs.catppuccin.nixosModules.catppuccin ];
  catppuccin = {
    enable = true;
    inherit flavor accent;
  };

  catppuccin.plymouth.enable = false;
  boot.plymouth.themePackages = [ pkgs.plymouth-blahaj-theme ];
  boot.plymouth.theme = "blahaj";

  hm.imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    self.hmModules.ctp-plus
  ];

  hm.catppuccin = {
    enable = true;
    inherit flavor accent;
  };

  hm.programs.fish.interactiveShellInit = ''
    set -x LS_COLORS (${lib.getExe pkgs.vivid} generate catppuccin-${flavor})
  '';

  hm.programs.konsole.catppuccin.font = {
    name = "Iosevka";
    size = 14;
  };

  hm.programs.moar.settings.style = "catppuccin-${flavor}";

  hm.programs.plasma.fonts =
    let
      rethink = {
        family = "Rethink Sans";
        pointSize = 12;
      };
    in
    {
      general = rethink // {
        pointSize = 14;
      };
      fixedWidth = {
        family = "Iosevka";
        pointSize = 14;
      };
      small = rethink // {
        pointSize = 11;
      };
      toolbar = rethink;
      menu = rethink;
      windowTitle = rethink;
    };

  roles.fonts = {
    enable = true;
    packages = with pkgs; [
      iosevka
      noto-fonts-color-emoji
      libertinus
      i-dot-ming
      lxgw-neoxihei
      dm-sans-unstable
    ];

    defaults = {
      serif = [
        "I.Ming"
      ];
      sansSerif = [
        "DM Sans"
        "LXGW Neo XiHei"
      ];
      emoji = [ "Noto Color Emoji" ];
      monospace = [
        "Iosevka"
        "LXGW Neo XiHei"
      ];
    };
  };
}
