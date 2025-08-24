{
  python3,
  fetchFromGitHub,
}:
let
  ahocorasick-python = python3.pkgs.buildPythonPackage {
    pname = "ahocorasick-python";
    version = "0.0.9";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "xizhicode";
      repo = "ahocorasick-python";
      # Release was not tagged
      rev = "d6b3609f06fe46e6387ff1d072164f6a08b2eaac";
      hash = "sha256-JqKzp1FN80XngqjpcECK5SXJ1u+FUA0Pl0NHsa6dBJI=";
    };

    build-system = [ python3.pkgs.setuptools ];
    pythonImportChecks = [ "ahocorasick" ];
  };
in
python3.pkgs.buildPythonApplication rec {
  pname = "tlsfragment";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maoist2009";
    repo = "TlsFragment";
    tag = "V${version}";
    hash = "sha256-Sby8amOYN3visAjIcYT0RPvwT6XuBkiIbym2BOsekLg=";
  };

  build-system = [ python3.pkgs.poetry-core ];

  dependencies = with python3.pkgs; [
    ahocorasick-python
    requests
    dnspython
  ];

  postPatch = ''
    sed -iE "s@^basepath = .*@basepath = Path('$out/share/tlsfragment')@" src/tls_fragment/config.py
    sed -iE "s@config_pac.json@$out/share/tlsfragment/config_pac.json@" src/tls_fragment/pac.py
  '';

  postInstall = ''
    install -Dm644 config.json config_pac.json -t $out/share/tlsfragment
  '';

  pythonImportChecks = [ "tlsfragment" ];
}
