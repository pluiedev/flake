{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "rime-japanese";
  version = "unstable-20230802";

  src = fetchFromGitHub {
    owner = "gkovacs";
    repo = "rime-japanese";
    rev = "4c1e65135459175136f380e90ba52acb40fdfb2d";
    hash = "sha256-/mIIyCu8V95ArKo/vIS3qAiD8InUmk8fAF/wejxRxGw=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/rime-data/
    cp japanese.*.yaml $out/share/rime-data/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Layout for typing in Japanese with RIME";
    homepage = "https://github.com/gkovacs/rime-japanese";
    license = licenses.free; # awaiting response from gkovacs/rime-japanese#6, presumably free
    maintainers = with maintainers; [pluiedev];
    platforms = platforms.all;
  };
}
