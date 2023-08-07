{lib, ...}: let
  inherit (lib) mkDefault;
in {
  nix = {
    gc = {
      automatic = mkDefault true;
      dates = mkDefault "weekly";
      options = mkDefault "--delete-older-than 7d";
    };

    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes" "auto-allocate-uids" "repl-flake"];
    };
  };
}
