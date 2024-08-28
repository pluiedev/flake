{
  lib,
  pkgs,
  config,
  inputs',
  ...
}:
let
  cfg = config.roles.rust;
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
in
{
  options.roles.rust = {
    enable = mkEnableOption "Rust";

    package = mkOption {
      type = types.package;
      default =
        let
          fenix = inputs'.fenix.packages;
        in
        fenix.combine [
          fenix.default.toolchain
          fenix.rust-analyzer
        ];
      description = "Version of Rust to install. Defaults to nightly with rust-analyzer";
    };

    linker = mkOption {
      type = types.nullOr types.pathInStore;
      default = lib.getExe' pkgs.mold "mold";
      example = "lib.getExe' pkgs.lld \"lld\"";
      description = "Linker to use when linking compiled Rust code";
    };

    settings = mkOption {
      type = types.nullOr (types.attrsOf types.anything);
      default = { };
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

  config.hm =
    let
      toml = pkgs.formats.toml { };
      linkerSettings = lib.optionalAttrs (cfg.linker != null) {
        target.${pkgs.rust.toRustTarget pkgs.hostPlatform} = {
          linker = "${lib.getExe pkgs.clang_16}";
          rustflags = [
            "-C"
            "link-arg=-fuse-ld=${cfg.linker}"
          ];
        };
      };
    in
    mkIf cfg.enable {
      home.packages = [ cfg.package ];

      xdg.configFile."rustfmt/rustfmt.toml".source = mkIf (cfg.rustfmt.settings != null)
          (toml.generate "rustfmt.toml" cfg.rustfmt.settings);

      home.file.".cargo/config.toml".source = mkIf (cfg.settings != null)
          (toml.generate "config.toml" (linkerSettings // cfg.settings));
    };
}
