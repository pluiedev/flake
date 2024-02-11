{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  flavors ? [],
}: let
  validFlavors = ["mocha" "macchiato" "frappe" "latte"];
in
  lib.checkListOfEnum "Invalid flavor, valid flavors are ${toString validFlavors}" validFlavors flavors
  stdenvNoCC.mkDerivation {
    pname = "catppuccin-sddm";
    version = "2023-12-05";

    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "sddm";
      rev = "95bfcba80a3b0cb5d9a6fad422a28f11a5064991";
      hash = "sha256-Jf4xfgJEzLM7WiVsERVkj5k80Fhh1edUl6zsSBbQi6Y=";
    };

    installPhase = let
      flavoursToInstall = builtins.concatStringsSep " " (map (x: "src/catppuccin-${x}") (
        if flavors == []
        then ["*"]
        else flavors
      ));
    in ''
      runHook preInstall

      mkdir -p $out/share/sddm/themes/
      cp -r ${flavoursToInstall} $out/share/sddm/themes/

      runHook postInstall
    '';
  }
