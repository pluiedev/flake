{
  projectRootFile = "flake.nix";

  programs = {
    biome.enable = true;
    black.enable = true;
    clang-format.enable = true;
    # fish-indent
    fourmolu.enable = true;
    just.enable = true;
    rustfmt.enable = true;
    shfmt.enable = true;
    stylua.enable = true;
    zig.enable = true;

    nixfmt.enable = true;
    statix.enable = true;
  };
}
