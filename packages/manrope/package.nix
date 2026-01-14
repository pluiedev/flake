{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation {
  pname = "manrope";
  version = "5-unstable-2026-01-14";

  src = fetchzip {
    url = "https://web.archive.org/web/20260114141147/https://www.shimmer.cloud/assets/manrope/manrope.zip";
    hash = "sha256-Vy65jiza41rTrrzU44oh272e7l+DmGL1wPdsMLij6BM=";
    stripRoot = false;
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 desktop/*.otf -t $out/share/fonts/opentype
    install -Dm644 variable/*.ttf -t $out/share/fonts/truetype
    runHook postInstall
  '';

  meta = {
    description = "Modern sans-serif font family";
    homepage = "https://www.shimmer.cloud/manrope";
    license = {
      fullName = "Manrope V5 Font Software License Agreement Version 1.0";
      url = "https://www.shimmer.cloud/manrope";
      free = false;
      redistributable = true;
    };
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      pluiedev
    ];
  };
}
