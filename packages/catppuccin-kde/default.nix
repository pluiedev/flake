{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  writeShellApplication,
  lightly-plasma ? {},
  gnutar,
  unzip,
  flavour ? "frappe",
  accent ? "blue",
  winDecStyle ? "modern",
  withLightly ? false,
}: let
  inherit (builtins) mapAttrs listToAttrs throw concatStringsSep attrNames;
  inherit (lib) pipe imap1 flip nameValuePair;

  # The ordering of these options is important; they must match the indicies in
  # the installation script.
  #
  # https://github.com/catppuccin/kde/blob/main/install.sh
  indices = mapAttrs (_:
    flip pipe [
      (imap1 (flip nameValuePair))
      listToAttrs
    ]) {
    flavour = [
      "mocha"
      "macchiato"
      "frappe"
      "latte"
    ];
    accent = [
      "rosewater"
      "flamingo"
      "pink"
      "mauve"
      "red"
      "maroon"
      "peach"
      "yellow"
      "green"
      "teal"
      "sky"
      "sapphire"
      "blue"
      "lavender"
    ];
    winDecStyle = [
      "modern"
      "classic"
    ];
  };

  options =
    mapAttrs (
      option: value:
        (indices.${option}).${value}
        or (
          throw "Invalid ${option} ${value}, valid ${option}s are: ${
            concatStringsSep ", " (attrNames indices.${option})
          }"
        )
    )
    {inherit flavour accent winDecStyle;};
in
  stdenvNoCC.mkDerivation rec {
    pname = "catppuccin-kde";
    version = "0.2.4";

    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-w77lzeSisx/PPxctMJKIdRJenq0s8HwR8gLmgNh4SH8=";
    };

    nativeBuildInputs = [
      unzip

      # Stub out tools for interactivity.
      (writeShellApplication {
        name = "sleep";
        text = "";
      })
      (writeShellApplication {
        name = "clear";
        text = "";
      })
      (writeShellApplication {
        name = "lookandfeeltool";
        text = "";
      })

      # Stub out tools that access the network.
      (writeShellApplication {
        name = "wget";
        text = "echo 2>&1 'Cannot use wget in the build environment!'; exit 1";
      })

      # As Plasma is not available in the build environment, do not dynamically
      # install packages.
      #
      # kpackagetool5 is only used by the install script to install the global theme.
      (writeShellApplication {
        name = "kpackagetool5";
        runtimeInputs = [gnutar];
        text = ''
          mkdir -p "''${XDG_DATA_HOME:-$HOME/.local/share}/plasma/look-and-feel"
          tar xf "$2" -C "''${XDG_DATA_HOME:-$HOME/.local/share}/plasma/look-and-feel"
        '';
      })
      (writeShellApplication {
        name = "kpackagetool6";
        text = ''kpackagetool5 "$@"'';
      })
    ];

    postPatch = ''
      patchShebangs .

      substituteInPlace install.sh \
        --replace-warn '$CONFIRMATION' Y \
        --replace-warn '  InstallCursor' ""
    '';

    buildPhase = ''
      runHook preBuild

      mkdir -p .local
      ${lib.optionalString withLightly "cp --recursive --dereference --no-preserve=all '${lightly-plasma}'/* .local"}
      HOME="$PWD" ./install.sh '${toString options.flavour}' '${toString options.accent}' '${toString options.winDecStyle}'

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mv .local "$out"

      runHook postInstall
    '';

    meta = with lib; {
      description = "Soothing pastel theme for KDE";
      homepage = "https://github.com/catppuccin/kde";
      license = licenses.mit;
      maintainers = with maintainers; [michaelBelsanti];
    };
  }
