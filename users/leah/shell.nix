{
  pkgs,
  user,
  ...
}: {
  users.users.${user.name}.shell = pkgs.fish;

  programs.fish.enable = true;

  programs.starship = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ./starship.toml);
  };
}
