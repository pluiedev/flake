{pkgs, ...}: {
  hm.home.packages = with pkgs; [
    # language servers
    lua-language-server
    ltex-ls
    marksman
    nil
    nodePackages_latest.diagnostic-languageserver
    nodePackages_latest.pyright
    nodePackages_latest.graphql-language-service-cli
    nodePackages_latest.svelte-language-server
    quick-lint-js
    ruff-lsp

    taplo
    typescript
    vscode-langservers-extracted

    # formatters
    alejandra
    black
    prettierd
    shfmt
    stylua

    tree-sitter
  ];
}
