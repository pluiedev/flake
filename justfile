# Shamelessly taken from https://github.com/getchoo/flake/blob/d80d49cc7652ea84810c4688212c48277dfc71be/justfile

alias b := build
alias c := check
alias sw := switch
alias t := test

default:
    @just --choose

[linux]
build:
    nixos-rebuild build --flake .
    nvd diff /run/current-system/ result/

[macos]
build:
    darwin-rebuild --flake .

check:
    nix flake check

[linux]
switch:
    sudo nixos-rebuild switch --flake .

[macos]
switch:
    darwin-rebuild switch --flake .

[linux]
test:
    sudo nixos-rebuild test --flake .

[macos]
test:
    darwin-rebuild test --flake .

update:
    nix flake update

update-nixpkgs:
    nix flake lock \
    	--update-input nixpkgs --update-input nixpkgs-stable
