{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  flavors ? [],
}: let
  validFlavors = ["mocha" "macchiato" "frappe" "latte"];
  mkUpper = str:
    with builtins;
      (lib.toUpper (substring 0 1 str)) + (substring 1 (stringLength str) str);
in
  #
  lib.checkListOfEnum "Invalid flavor, valid flavors are ${toString validFlavors}" validFlavors flavors
  stdenvNoCC.mkDerivation {
    pname = "catppuccin-konsole";
    version = "2022-11-09";

    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "konsole";
      rev = "7d86b8a1e56e58f6b5649cdaac543a573ac194ca";
      hash = "sha256-EwSJMTxnaj2UlNJm1t6znnatfzgm1awIQQUF3VPfCTM=";
    };

    installPhase = let
      flavoursToInstall = builtins.concatStringsSep " " (map (x: "Catppuccin-${mkUpper x}.colorscheme") (
        if flavors == []
        then ["*"]
        else flavors
      ));
    in ''
      runHook preInstall

      mkdir -p $out/share/konsole/
      cp -r ${flavoursToInstall} $out/share/konsole/

      runHook postInstall
    '';
  }
