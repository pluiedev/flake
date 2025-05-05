{
  rustPlatform,
  fetchFromGitHub,
}:
let
  version = "1.0.0";
in
rustPlatform.buildRustPackage {
  pname = "meowpdf";
  inherit version;

  src = fetchFromGitHub {
    owner = "monoamine11231";
    repo = "meowpdf";
    tag = "v${version}";
    hash = "sha256-C5GqyZW0pDmBuaKM890hx2JZtkZqZx+x/RZFCPhpjho=";
  };

  cargoHash = "sha256-hCGMm0ORKuyyWU5D9k+nthSwmq8ALz0qASLDaMiW30U=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];
}

