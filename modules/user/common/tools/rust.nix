{
  osConfig,
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.pluie.user.tools.rust;
  inherit (lib) mkIf mkOption mkEnableOption types;

  toTOMLFile = pkgs.formats.toml {};
in {
  options.pluie.user.tools.rust = {
    enable = mkEnableOption "Rust";

    rust-bin = mkOption {
      type = types.attrsOf types.anything;
      default = pkgs.rust-bin // lib.optionalAttrs osConfig.pluie.enableChineseMirrors {distRoot = "https://mirror.sjtu.edu.cn/rust-static/dist";};
      example = pkgs.rust-bin // {distRoot = "some-root";};
    };

    package = mkOption {
      type = types.package;
      default = builtins.trace cfg.rust-bin.distRoot cfg.rust-bin.selectLatestNightlyWith (toolchain:
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
      default = lib.optionalAttrs osConfig.pluie.enableChineseMirrors {
        source = {
          crates-io.replace-with = "sjtu";

          tuna.registry = "sparse+https://mirrors.tuna.tsinghua.edu.cn/crates.io-index/";
          ustc.registry = "sparse+https://mirrors.ustc.edu.cn/crates.io-index/";
          sjtu.registry = "sparse+https://mirrors.sjtug.sjtu.edu.cn/crates.io-index/";
        };
      };
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
}
