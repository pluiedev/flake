{
  lib,
  pkgs,
  config,
  rust-overlay,
  ...
}: let
  cfg = config.roles.rust;
  inherit (lib) mkIf mkOption mkEnableOption types;
in {
  options.roles.rust = {
    enable = mkEnableOption "Rust";

    rust-bin = mkOption {
      type = types.attrsOf types.anything;
      default = pkgs.rust-bin;
      example = pkgs.rust-bin // {distRoot = "some-root";};
    };

    package = mkOption {
      type = types.package;
      default = cfg.rust-bin.selectLatestNightlyWith (toolchain:
        toolchain.default.override {
          extensions = ["rust-analyzer"];
        });
      example = cfg.rust-bin.stable.latest.default;
      description = "Version of Rust to install. Defaults to latest nightly with rust-analyzer";
    };

    linker = mkOption {
      type = types.nullOr types.pathInStore;
      default = lib.getExe' pkgs.mold "mold";
      example = "lib.getExe' pkgs.lld \"lld\"";
      description = "Linker to use when linking compiled Rust code";
    };

    settings = mkOption {
      type = types.nullOr (types.attrsOf types.anything);
      default = {};
    };

    rustfmt.settings = mkOption {
      type = types.nullOr (types.attrsOf types.anything);
      default = null;
      example = {
        hard_tabs = true;
        tab_spaces = 4;
        newline_style = "Unix";
      };
    };
  };

  config = let
    toTOMLFile = pkgs.formats.toml {};
  in
    mkIf cfg.enable {
      nixpkgs.overlays = [rust-overlay.overlays.default];

      hm = {
        home.packages = [cfg.package];

        xdg.configFile."rustfmt/rustfmt.toml" = mkIf (cfg.rustfmt.settings != null) {
          source = toTOMLFile.generate "rustfmt.toml" cfg.rustfmt.settings;
        };

        home.file.".cargo/config.toml" = mkIf (cfg.settings != null) {
          source = toTOMLFile.generate "config.toml" (
            (lib.optionalAttrs (cfg.linker != null) {
              target.${pkgs.rust.toRustTarget pkgs.hostPlatform} = {
                linker = "${lib.getExe pkgs.clang_16}";
                rustflags = ["-C" "link-arg=-fuse-ld=${cfg.linker}"];
              };
            })
            // cfg.settings
          );
        };
      };
    };
}
