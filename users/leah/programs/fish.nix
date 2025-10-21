{
  config,
  lib,
  pkgs,
  ...
}:
{

  programs.fish.enable = true;
  users.users.leah.shell = config.programs.fish.package;

  hjem.users.leah.rum.programs = {
    direnv.integrations.fish.enable = true;
    starship.integrations.fish.enable = true;
  };

  hjem.users.leah.rum.programs.fish = {
    enable = true;
    inherit (config.programs.fish) package;

    abbrs = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -a";
      lt = "eza --tree";
      lla = "eza -la";
    };

    config = ''
      function eza --wraps eza
        command eza --git --icons=auto $argv
      end
    '';
  };
}
