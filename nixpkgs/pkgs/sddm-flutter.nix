{
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "sddm-theme-flutter";
  version = "0.2";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/sddm/themes
    cp -a $src $out/share/sddm/themes/flutter

    runHook postInstall
  '';
  src = fetchFromGitHub {
    owner = "pluiedev";
    repo = "sddm-flutter";
    rev = "8d5f8318a6b3ac8883197770ba39dc25764ef937";
    sha256 = "bc6vKmTunvy0T5fgdlV0HGYOWiKGQGxvuu1+lNHfgY8=";
  };
}
