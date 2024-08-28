{
  dm-sans,
  fetchFromGitHub
}:
dm-sans.overrideAttrs {
  version = "1.002-unstable-2024-07-03";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "dm-fonts";
    url = "https://github.com/googlefonts/dm-fonts";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/{opentype,truetype,woff}
    cp Sans/fonts/otf/*.otf $out/share/fonts/opentype
    cp Sans/fonts/{ttf,variable}/*.ttf $out/share/fonts/truetype
    cp Sans/fonts/webfonts/*.woff2 $out/share/fonts/woff

    cp Serif/Exports/*.ttf $out/share/fonts/truetype

    runHook postInstall
  '';
}
