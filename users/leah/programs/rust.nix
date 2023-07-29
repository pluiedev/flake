{pkgs, ...}: {
  xdg.configFile."rustfmt/rustfmt.toml" = {
    source = ../../../templates/rust/rustfmt.toml;
  };
  home.packages = with pkgs; [
    (rust-bin.selectLatestNightlyWith (toolchain:
      toolchain.default.override {
        extensions = ["rust-analyzer"];
      }))
  ];
}
