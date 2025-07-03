{
  lib,
  dm-sans,
  fetchFromGitHub,

  # DM Sans has specialized variants at various font sizes to presumably improve legibility.
  # This is disabled by default to decrease closure size (a decrease of 13.2MiB!)
  enableSizeSpecialization ? false,

  # You can't really use web fonts on desktop anyway (removes 22.6MiB!!!)
  enableWebFonts ? false,
}:
dm-sans.overrideAttrs {
  version = "1.002-unstable-2024-07-03";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "dm-fonts";
    rev = "4412393b7d2de9fe7a92064c2dce9b5af5d7fd26";
    hash = "sha256-Zh5YBQaMKSnOHLK9XNj5+ExQY0357GTsbYOvi1Q87+0=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/{opentype,truetype,woff}
    cp Sans/fonts/otf/*.otf $out/share/fonts/opentype

    cp Sans/fonts/ttf/${
      lib.optionalString (!enableSizeSpecialization) "DMSans-"
    }*.ttf $out/share/fonts/truetype
    cp Sans/fonts/variable/*.ttf $out/share/fonts/truetype
    ${lib.optionalString enableWebFonts ''cp Sans/fonts/webfonts/*.woff2 $out/share/fonts/woff''}

    cp Serif/Exports/*.ttf $out/share/fonts/truetype

    runHook postInstall
  '';
}
