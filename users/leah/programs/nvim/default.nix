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
    # language servers
    lua-language-server
    ltex-ls
    marksman
    nixd
    nodePackages_latest.diagnostic-languageserver
    nodePackages_latest.pyright
    nodePackages_latest.graphql-language-service-cli
    quick-lint-js
    ruff-lsp
    taplo
    vscode-langservers-extracted

    # formatters
    alejandra
    black
    prettierd
    shfmt
    stylua

    tree-sitter
    neovide
    nvimpager
  ];
  home.sessionVariables.NEOVIDE_MULTIGRID = "1";
}
