# Shamelessly taken from https://github.com/getchoo/flake/blob/d80d49cc7652ea84810c4688212c48277dfc71be/justfile

alias b := build
alias c := check
alias sw := switch
alias t := test

default:
    @just --choose

[linux]
build *args:
    nixos-rebuild build --flake . {{args}}
    nix run n#nvd -- diff /run/current-system/ result/

[macos]
build:
    darwin-rebuild --flake .

check:
    nix flake check

[linux]
switch *args:
    @sudo -v
    sudo nixos-rebuild switch --flake .#$(hostname) --keep-going -L {{args}} |& nix run n#nix-output-monitor

[macos]
switch *args:
    darwin-rebuild switch --flake . --keep-going -L {{args}}

[linux]
test:
    sudo nixos-rebuild test --flake .

[macos]
test:
    darwin-rebuild test --flake .

update: (switch "--recreate-lock-file")
