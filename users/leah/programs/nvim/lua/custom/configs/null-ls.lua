local null_ls = require "null-ls"
local builtins = null_ls.builtins
local diagnostics = builtins.diagnostics
local formatting = builtins.formatting

return {
  sources = {
    diagnostics.mypy,
    diagnostics.ruff,

    formatting.black,
    formatting.stylua,
    formatting.alejandra,
  },
  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      local formatting_ag = vim.api.nvim_create_augroup("LspFormatting", {})

      vim.api.nvim_clear_autocmds {
        group = formatting_ag,
        buffer = bufnr,
      }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = formatting_ag,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { bufnr = bufnr }
        end,
      })
    end
  end,
}
