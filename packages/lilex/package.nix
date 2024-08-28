{
  lib,

  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lilex";
  version = "2.530";

  src = fetchFromGitHub {
    owner = "mishamyrt";
    repo = "Lilex";
    rev = finalAttrs.version;
    hash = "sha256-Es4LEXS2yXOe0QjtaGbxjGsIOnKxnRom8xJo3hX+sIg=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm644 fonts/variable/*.ttf fonts/ttf/*.ttf -t $out/share/fonts/opentype
    runHook postInstall
  '';

  meta = {
    description = "Modern programming font containing a set of ligatures for common programming multi-character combinations";
    homepage = "https://github.com/mishamyrt/Lilex";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ pluiedev ];
    platforms = lib.platforms.all;
  };
})
