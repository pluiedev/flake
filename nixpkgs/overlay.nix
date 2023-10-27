final: prev: {
  sddm-theme-flutter = final.callPackage ./pkgs/sddm-flutter.nix {};

  hyprshot = final.callPackage ./pkgs/hyprshot.nix {};
  vesktop = final.callPackage ./pkgs/vesktop-0.4.nix {};
}
