{
  config,
  lib,
  ...
}: let
  cfg = config.pluie.user.ime;
  inherit (lib) mkOption mkIf types;
in {
  imports = [
    ./fcitx5.nix
    ./ibus.nix
    ./rime.nix
  ];

  options.pluie.user.ime = {
    enabled = mkOption {
      type = types.nullOr (types.enum ["fcitx5" "ibus"]);
      default = "fcitx5";
      example = "fcitx5";
      description = "The IME backend to use.";
    };
    engines = mkOption {
      type = types.listOf types.str;
      default = ["rime" "mozc"];
      example = ["rime"];
      description = ''
        List of engines to use. Must be available for all supported IME backends.
        Fcitx5 engines (addons) are found at `pkgs.fcitx5-''${engine}`.
        IBus engines are found at `pkgs.ibus-engines.''${engine}`.
      '';
    };
  };

  config = mkIf (cfg.enabled != null) {
    i18n.inputMethod.enabled = cfg.enabled;
  };
}
