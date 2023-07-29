require("formatter").setup {
  filetype = {
    css = { require("formatter.filetypes.css").prettier },
    html = { require("formatter.filetypes.html").prettier },
    graphql = { require("formatter.filetypes.graphql").prettier },
    javascript = { require("formatter.filetypes.javascript").prettier },
    javascriptreact = { require("formatter.filetypes.javascriptreact").prettier },
    json = { require("formatter.filetypes.json").prettier },
    markdown = { require("formatter.filetypes.markdown").prettier },
    svelte = { require("formatter.filetypes.svelte").prettier },
    typescript = { require("formatter.filetypes.typescript").prettier },
    typescriptreact = { require("formatter.filetypes.typescriptreact").prettier },
    yaml = { require("formatter.filetypes.yaml").prettier },

    fish = { require("formatter.filetypes.fish").fishindent },
    lua = { require("formatter.filetypes.lua").stylua },
    nix = { require("formatter.filetypes.nix").alejandra },
    python = { require("formatter.filetypes.python").black },
    sh = { require("formatter.filetypes.sh").shfmt },
    toml = { require("formatter.filetypes.toml").taplo },

    ["*"] = {
      require("formatter.filetypes.any").remove_trailing_whitespace,
    },
  },
}
