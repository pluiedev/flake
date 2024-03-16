{pkgs, ...}: {
  imports = [
    ./lsp.nix
    ./plugins.nix
  ];

  hm = {
    xdg.configFile."nvim/lua" = {
      source = ./lua;
      recursive = true;
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      extraLuaConfig = builtins.readFile ./init.lua;
    };

    home.packages = with pkgs; [
      neovide
      nvimpager
    ];
  };
}
