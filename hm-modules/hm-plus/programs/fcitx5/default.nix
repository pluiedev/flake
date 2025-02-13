{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkMerge
    mkIf
    mkOption
    types
    literalExpression
    ;
  im = config.i18n.inputMethod;
  cfg = im.fcitx5;

  fcitx5Package =
    if cfg.plasma6Support then
      pkgs.qt6Packages.fcitx5-with-addons.override { inherit (cfg) addons; }
    else
      pkgs.libsForQt5.fcitx5-with-addons;

  fcitx5Package' = fcitx5Package.override { inherit (cfg) addons; };

  format = pkgs.formats.ini { };
  formatWithGlobalSection = pkgs.formats.iniWithGlobalSection { };
in
{
  imports = [ ./rime.nix ];

  options.i18n.inputMethod.fcitx5 = {
    plasma6Support = mkOption {
      type = types.bool;
      default = osConfig.services.desktopManager.plasma6.enable;
      defaultText = literalExpression "config.services.desktopManager.plasma6.enable";
      description = ''
        Use qt6 versions of fcitx5 packages.
        Required for configuring fcitx5 in KDE System Settings.
      '';
    };
    quickPhrase = mkOption {
      type = with types; attrsOf str;
      default = { };
      example = literalExpression ''
        {
          smile = "（・∀・）";
          angry = "(￣ー￣)";
        }
      '';
      description = "Quick phrases.";
    };
    quickPhraseFiles = mkOption {
      type = with types; attrsOf path;
      default = { };
      example = literalExpression ''
        {
          words = ./words.mb;
          numbers = ./numbers.mb;
        }
      '';
      description = "Quick phrase files.";
    };
    settings = {
      globalOptions = mkOption {
        type = types.submodule { freeformType = format.type; };
        default = { };
        description = ''
          The global options in `config` file in ini format.
        '';
      };
      inputMethod = mkOption {
        type = types.submodule { freeformType = format.type; };
        default = { };
        description = ''
          The input method configure in `profile` file in ini format.
        '';
      };
      addons = mkOption {
        type = with types; (attrsOf anything);
        default = { };
        description = ''
          The addon configures in `conf` folder in ini format with global sections.
          Each item is written to the corresponding file.
        '';
        example = literalExpression "{ pinyin.globalSection.EmojiEnabled = \"True\"; }";
      };
    };
    ignoreUserConfig = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Ignore the user configures. **Warning**: When this is enabled, the
        user config files are totally ignored and the user dict can't be saved
        and loaded.
      '';
    };
  };

  config = mkIf (im.enabled == "fcitx5") {
    # override HM defaults
    i18n.inputMethod.package = lib.mkForce fcitx5Package';

    i18n.inputMethod.fcitx5.addons =
      lib.optionals (cfg.quickPhrase != { }) [
        (pkgs.writeTextDir "share/fcitx5/data/QuickPhrase.mb" (
          lib.concatStringsSep "\n" (lib.mapAttrsToList (name: value: "${name} ${value}") cfg.quickPhrase)
        ))
      ]
      ++ lib.optionals (cfg.quickPhraseFiles != { }) [
        (pkgs.linkFarm "quickPhraseFiles" (
          lib.mapAttrs' (
            name: value: lib.nameValuePair "share/fcitx5/data/quickphrase.d/${name}.mb" value
          ) cfg.quickPhraseFiles
        ))
      ];

    xdg.configFile =
      let
        optionalFile =
          p: f: v:
          lib.optionalAttrs (v != { }) { "fcitx5/${p}".source = f p v; };
      in
      lib.attrsets.mergeAttrsList [
        (optionalFile "config" format cfg.settings.globalOptions)
        (optionalFile "profile" format cfg.settings.inputMethod)
        (lib.concatMapAttrs (
          name: value: optionalFile "conf/${name}.conf" formatWithGlobalSection value
        ) cfg.settings.addons)
      ];

    home.sessionVariables = mkMerge [
      (mkIf cfg.ignoreUserConfig { SKIP_FCITX_USER_PATH = "1"; })
    ];
  };
}
