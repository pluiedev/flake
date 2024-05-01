{pkgs, ...}: {
  catppuccin-fcitx5 = pkgs.callPackage ./catppuccin-fcitx5 {};
  catppuccin-sddm = pkgs.callPackage ./catppuccin-sddm {};
  catppuccin-konsole = pkgs.callPackage ./catppuccin-konsole {};
  rethink-sans = pkgs.callPackage ./rethink-sans {};
}
