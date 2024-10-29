{ pkgs, ... }:
{
  hm.home.packages =
    with pkgs;
    [
      # Language servers
      lua-language-server
      ltex-ls
      marksman
      nil
      pyright
      quick-lint-js
      ruff-lsp
      taplo
      typescript-language-server
      vscode-langservers-extracted
      zls

      # Formatters
      black
      nixfmt-rfc-style
      prettierd
      shfmt
      stylua

      tree-sitter
    ]
    ++ (with pkgs.nodePackages_latest; [
      diagnostic-languageserver
      graphql-language-service-cli
      svelte-language-server
    ]);
}
