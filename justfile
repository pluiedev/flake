# Shamelessly taken from https://github.com/getchoo/flake/blob/d80d49cc7652ea84810c4688212c48277dfc71be/justfile

alias b := build
alias c := check
alias d := deploy
alias f := fmt
alias l := lint
alias p := pre-commit
alias sw := switch
alias t := test

default:
    @just --choose

[linux]
build:
    nixos-rebuild build --flake .

[macos]
build:
    darwin-rebuild --flake .

check:
    nix flake check

deploy HOST:
    nix run .#{{ HOST }}

fmt:
    pre-commit run alejandra && pre-commit run stylua

lint:
    pre-commit run statix && pre-commit run deadnix

pre-commit:
    pre-commit run

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
