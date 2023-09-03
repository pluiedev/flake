{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.pluie.tools.rust;
  inherit (lib) mkIf mkOption mkEnableOption types;

  toTOMLFile = pkgs.formats.toml {};
in {
  options.pluie.tools.rust = {
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
      type = types.pathInStore;
      default = lib.getExe' pkgs.mold "mold";
      example = "lib.getExe' pkgs.lld \"lld\"";
      description = "Linker to use when linking compiled Rust code";
    };

    settings = mkOption {
      type = types.attrsOf types.anything;
      default = {};
      example = {
        source = {
          crates-io.replace-with = "tuna";
          tuna.registry = "sparse+https://mirrors.tuna.tsinghua.edu.cn/crates.io-index/";
        };
      };
    };

    rustfmtSettings = mkOption {
      type = types.attrsOf types.anything;
      default = {};
      example = {
        hard_tabs = true;
        tab_spaces = 4;
        newline_style = "Unix";
      };
    };
  };

  config = mkIf cfg.enable {
    pluie.user.config = {
      home.packages = [cfg.package];

      xdg.configFile."rustfmt/rustfmt.toml".source = toTOMLFile.generate "rustfmt.toml" cfg.rustfmtSettings;

      home.file.".cargo/config.toml".source = toTOMLFile.generate "config.toml" ({
          target.${pkgs.rust.toRustTarget pkgs.hostPlatform} = {
            linker = "clang";
            rustflags = ["-C" "link-arg=-fuse-ld=${cfg.linker}"];
          };
        }
        // cfg.settings);
    };
  };
}
