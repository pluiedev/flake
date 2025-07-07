{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "bitter";
  version = "1.010-unstable-2025-02-12";

  src = fetchFromGitHub {
    owner = "solmatas";
    repo = "BitterPro";
    rev = "3238d7ae2cb0b564b81225d68b3c893a40b1d3ce";
    hash = "sha256-yWUHCob0ExcMIf1NE4Ch49+rTd2uJJPdotUQTWEclK8=";
  };

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 -t $out/share/fonts/truetype fonts/variable/*.ttf
    runHook postInstall
  '';

  meta = {
    license = lib.licenses.ofl;
    platform = lib.platforms.all;
  };
}
