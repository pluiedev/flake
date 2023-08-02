local formatters = require "format-on-save.formatters"

require("format-on-save").setup {
  formatter_by_ft = {
    css = formatters.prettierd,
    html = formatters.prettierd,
    graphql = formatters.prettierd,
    javascript = formatters.prettierd,
    javascriptreact = formatters.prettierd,
    json = formatters.prettierd,
    markdown = formatters.prettierd,
    svelte = formatters.prettierd,
    typescript = formatters.prettierd,
    typescriptreact = formatters.prettierd,
    yaml = formatters.prettierd,

    --fish = { require("formatter.filetypes.fish").fishindent },
    lua = formatters.stylua,
    nix = formatters.shell { cmd = { "alejandra", "-qq", "-" } },
    python = formatters.black,
    sh = formatters.shfmt,
  },
  fallback_formatter = {
    formatters.remove_trailing_whitespace,
  },
}
