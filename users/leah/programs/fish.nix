{
  config,
  ...
}:
{

  programs.fish.enable = true;
  users.users.leah.shell = config.programs.fish.package;

  hjem.users.leah.rum.programs.fish = {
    enable = true;
    inherit (config.programs.fish) package;
    
    functions.eza = "eza --git --icons=auto";
    abbrs = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -a";
      lt = "eza --tree";
      lla = "eza -la";
    };
  };
}
