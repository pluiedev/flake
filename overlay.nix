# May lord have mercy on my soul
{
  self,
  ...
}:
{
  flake.overlays.default =
    final: prev:
    let
      inherit (prev.stdenv.hostPlatform) system;

      myPkgs = prev.lib.optionalAttrs (builtins.hasAttr system self.packages) self.packages.${system};
    in
    myPkgs
    // {
      jujutsu = prev.jujutsu.overrideAttrs {
        patches = (prev.patches or [ ]) ++ [
          # HACK: I am so sick and tired of not being able to push to Nixpkgs
          # because some edgy fucking idiot thought that it's a good idea to not
          # specify an email address in a commit
          #
          # See https://github.com/NixOS/nixpkgs/pull/453871
          # See https://github.com/jj-vcs/jj/issues/5723
          (prev.fetchpatch2 {
            url = "https://github.com/pluiedev/jj/commit/daa88d4dd485ed0c188023d2af8f811fd4db4a14.patch";
            hash = "sha256-F8fp+LXQwuFVVVnYHJAEaQ9dFr6z9tdCkmcKDC39mM8=";
          })
        ];
        doCheck = false;
      };

      # TODO: Remove when nixpkgs#473189 is available in unstable
      vicinae = final.runCommand "vicinae-patched" { } ''
        mkdir -p $out
        cp -r ${prev.vicinae}/* $out
        substituteInPlace $out/share/systemd/user/vicinae.service \
          --replace-fail "/bin/kill" "${final.lib.getExe' final.coreutils "kill"}" \
          --replace-fail "vicinae" "$out/bin/vicinae"
      '';
    };
}
