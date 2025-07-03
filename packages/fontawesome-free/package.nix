{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fontawesome-free";
  version = "6.7.2";

  src = fetchzip {
    url = "https://use.fontawesome.com/releases/v${finalAttrs.version}/fontawesome-free-${finalAttrs.version}-desktop.zip";
    hash = "sha256-jkXTyVyK2OtHQTykMAjrov0cpj4Kktk/cn4bEMHi6tY=";
  };

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 otfs/*.otf -t $out/share/fonts/opentype
    install -Dm644 LICENSE.txt -t $out/share/doc/fontawesome
    runHook postInstall
  '';

  meta = {
    description = "Font Awesome OpenType fonts (Free version)";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
