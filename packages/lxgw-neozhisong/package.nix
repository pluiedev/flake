{
  lib,
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lxgw-neozhisong";
  version = "1.032";

  src = fetchurl {
    url = "https://github.com/lxgw/LxgwNeoZhiSong/releases/download/v${finalAttrs.version}/LXGWNeoZhiSong.ttf";
    hash = "sha256-COW12RkXoiKemv5Uq2FshkxkFiLcyWktApCd6Y+vheY=";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 $src $out/share/fonts/truetype/LXGWNeoZhiSong.ttf
    runHook postInstall
  '';

  meta = {
    license = lib.licenses.ipa;
    platform = lib.platforms.all;
  };
})
