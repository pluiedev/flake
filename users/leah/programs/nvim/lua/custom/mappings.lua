return {
  crates = {
    n = {
      ["<leader>cru"] = {
        function()
          require("crates").upgrade_all_crates()
        end,
        "Update all crates",
      },
    },
  },
}
