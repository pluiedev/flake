{
  inputs = {
    nixpkgs.url = "nixpkgs";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    rust-overlay,
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (sys: f nixpkgs.legacyPackages.${sys});
  in {
    devShell = forAllSystems (pkgs:
      with pkgs;
        mkShell {
          buildInputs = [
            rust-bin.selectLatestNightlyWith
            (toolchain:
              toolchain.default.override {
                extensions = ["rust-analyzer"];
              })
          ];
        });
  };
}
