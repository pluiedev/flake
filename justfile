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
  nix flake check

switch *args: (_rebuild "switch" args)
test *args: (_rebuild "test" args)

update: (switch "--recreate-lock-file")

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
additional_build_flags := if os() == "linux" { "${NIXOS_SPECIALISATION:+--specialisation $NIXOS_SPECIALISATION}" } else { "" }

_rebuild cmd *args:
  {{rebuild}} {{cmd}} {{common_build_flags}} {{additional_build_flags}} {{args}} |& nix run n#nix-output-monitor

