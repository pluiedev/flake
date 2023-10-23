final: prev: {
  sddm-theme-flutter = final.callPackage ./pkgs/sddm-flutter.nix {};

  vesktop = final.callPackage ./pkgs/vesktop-0.4.nix {};
}
