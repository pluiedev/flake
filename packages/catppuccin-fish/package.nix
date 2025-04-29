{
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "catppuccin-fish";
  version = "0-unstable-2025-03-01";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "fish";
    rev = "6a85af2ff722ad0f9fbc8424ea0a5c454661dfed";
    hash = "sha256-Oc0emnIUI4LV7QJLs4B2/FQtCFewRFVp7EDv8GawFsA=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fish
    cp -r themes $out/share/fish/themes
    runHook postInstall
  '';
}
