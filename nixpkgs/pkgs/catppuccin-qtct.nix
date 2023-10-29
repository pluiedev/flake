{
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "catppuccin-qtct";
  version = "2023-03-21";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "qt5ct";
    rev = "89ee948e72386b816c7dad72099855fb0d46d41e";
    hash = "sha256-t/uyK0X7qt6qxrScmkTU2TvcVJH97hSQuF0yyvSO/qQ=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/qt5ct/colors
    cp -a themes/* $out/share/qt5ct/colors
    runHook postInstall
  '';
}
