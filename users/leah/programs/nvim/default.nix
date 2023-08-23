{pkgs, ...}: {
  xdg.configFile.nvim = {
    source = ./.;
    recursive = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  home.packages = with pkgs; [
    alejandra
    black
    lua-language-server
    nil
    nodePackages_latest.pyright
    prettierd
    ruff
    ruff-lsp
    shfmt
    stylua
    taplo
    tree-sitter

    neovide
    nvimpager
  ];
  home.sessionVariables.NEOVIDE_MULTIGRID = "1";
}
