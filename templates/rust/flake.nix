{
  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils }: 
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in 
      {
        devShell = with pkgs; mkShell {
          buildInputs = with pkgs; [
            rust-bin.selectLatestNightlyWith (toolchain: toolchain.default.override {
              extensions = ["rust-analyzer"];
            })
            pre-commit
          ]
        }
      }
    )
}
