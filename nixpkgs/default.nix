{
  perSystem = {pkgs, ...}: {
    packages = {
      catppuccin-fcitx5 = pkgs.callPackage ./pkgs/catppuccin-fcitx5.nix {};
      catppuccin-qtct = pkgs.callPackage ./pkgs/catppuccin-qtct.nix {};
    };
  };
}
