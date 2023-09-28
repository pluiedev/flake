{
  config,
  lib,
  nixpkgs,
  nur,
  rust-overlay,
  ...
}: let
  inherit (lib) mkDefault mkIf;
in {
  nix = {
    registry = {
      nixpkgs.flake = nixpkgs;
      n.flake = nixpkgs;
    };
    gc = {
      automatic = mkDefault true;
      dates = mkDefault "weekly";
      options = mkDefault "--delete-older-than 7d";
    };

    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes" "auto-allocate-uids" "repl-flake"];

      trusted-users = ["@wheel"];

      # cache.nixos.org is *unbearably* slow when accessed from Mainland China.
      # Fortunately, mirror sites exist... Hooray(?)
      substituters = mkIf config.pluie.enableChineseMirrors [
        "https://mirrors.sjtug.sjtu.edu.cn/nix-channels/store/"
        "https://mirrors.ustc.edu.cn/nix-channels/store/"
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      ];
    };
  };
  nixpkgs = {
    # I'm not part of the FSF and I don't care
    config.allowUnfree = true;

    overlays = [
      nur.overlay
      rust-overlay.overlays.default
      (import ../../nixpkgs/overlay.nix)
    ];
  };
}
