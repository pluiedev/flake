# Uses &&
set unstable

alias b := build
alias c := check
alias sw := switch
alias t := test

default:
    @just --choose

[linux]
build *args: (_rebuild "build" args)
    nix run nixpkgs#nvd -- diff /run/current-system/ result/

[macos]
build *args: (_rebuild "build" args)

check:
    nix flake check --option allow-import-from-derivation true

switch *args: (_rebuild "switch" args)

test *args: (_rebuild "test" args)

# blatantly stolen from getchoo
ci:
    nix run \
      --inputs-from . \
      --override-input nixpkgs nixpkgs \
      github:Mic92/nix-fast-build -- \
      --no-nom \
      --skip-cached \
      --option accept-flake-config true \
      --option allow-import-from-derivation true \
      --flake '.#hydraJobs'

#=== ABSTRACTION ==#

rebuild := if os() == "macos" { "darwin-rebuild" } else { "nixos-rebuild" }
common_build_flags := "--flake .#$HOSTNAME --keep-going -L"
specialisation := env("NIXOS_SPECIALISATION", "")
additional_build_flags := if os() == "linux" { specialisation && "-c " + specialisation } else { "" }

_rebuild cmd *args:
    #!/usr/bin/env bash
    set -o pipefail # fail if the build fails instead of blindly returning 0 as nom succeeds
    {{ rebuild }} {{ cmd }} {{ common_build_flags }} {{ if cmd != "build" { additional_build_flags } else { " " } }} {{ args }} |& nix run n#nix-output-monitor
