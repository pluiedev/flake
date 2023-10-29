final: prev: {
  catppuccin-qtct = final.callPackage ./pkgs/catppuccin-qtct.nix {};

  hyprshot = final.callPackage ./pkgs/hyprshot.nix {};
  vesktop = final.callPackage ./pkgs/vesktop-0.4.nix {};
}
