{ self, inputs, pkgs, ... }:
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

  hm.imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    self.hmModules.ctp-plus
  ];
  hm.catppuccin = {
    enable = true;
    inherit flavor accent;
  };

  hm.programs.konsole.catppuccin.font = {
    name = "Iosevka Nerd Font";
    size = 12;
  };

  roles.fonts = {
    enable = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Iosevka" ]; })
      lilex
      noto-fonts
      noto-fonts-emoji
      libertinus
      lxgw-wenkai
      lxgw-neoxihei
      dm-sans-unstable
    ];

    defaults = {
      serif = [
        "DM Serif Text"
        "LXGW WenKai"
      ];
      sansSerif = [
        "DM Sans"
        "LXGW Neo XiHei"
      ];
      emoji = [ "Noto Color Emoji" ];
      monospace = [
        "Iosevka Nerd Font"
        "LXGW Neo XiHei"
      ];
    };
  };
}
