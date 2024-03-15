{pkgs, ...}: {
  catppuccin-fcitx5 = pkgs.callPackage ./catppuccin-fcitx5 {};
  catppuccin-sddm = pkgs.callPackage ./catppuccin-sddm {};
  catppuccin-konsole = pkgs.callPackage ./catppuccin-konsole {};
  catppuccin-kde-new = pkgs.callPackage ./catppuccin-kde {};
  rime-japanese = pkgs.callPackage ./rime-japanese {};
}
