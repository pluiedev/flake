{pkgs, ...}: {
  hm.home.packages = with pkgs; [
    # Language servers
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

    # Formatters
    alejandra
    black
    prettierd
    shfmt
    stylua

    tree-sitter
  ];
}
