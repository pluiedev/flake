{
  programs = {
    fish.enable = true;

    starship = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };

    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
