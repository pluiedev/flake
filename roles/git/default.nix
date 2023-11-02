{
  config,
  lib,
  ...
}: let
  inherit (lib) mkAliasOptionModule mkEnableOption mkOption mkIf types;
  cfg = config.roles.git;
in {
  imports = [
    (mkAliasOptionModule ["roles" "git" "signing" "key"] ["hm" "programs" "git" "signing" "key"])
  ];

  options.roles.git = {
    enable = mkEnableOption "Git";

    name = mkOption {
      type = types.nullOr types.str;
      default = config.roles.base.fullName;
    };

    email = mkOption {
      type = types.nullOr types.str;
      default = null;
    };

    signing = {
      enabledByDefault = mkEnableOption "Git signing by default." // {default = true;};

      format = mkOption {
        type = types.enum ["openpgp" "ssh" "x509"];
        default = "ssh";
      };

      signer = mkOption {
        type = types.nullOr types.path;
        default = null;
      };
    };
  };

  config = mkIf cfg.enable {
    hm = {
      programs.git = {
        enable = true;
        userName = cfg.name;
        userEmail = cfg.email;

        signing.signByDefault = cfg.signing.enabledByDefault;

        extraConfig = {
          gpg = {
            inherit (cfg.signing) format;
            ${cfg.signing.format}.program = mkIf (cfg.signing.signer != null) cfg.signing.signer;
          };

          init.defaultBranch = "main";
          push.autoSetupRemote = true;
        };
      };

      programs.gh = {
        enable = true;
        settings.git_protocol = "ssh";
      };
    };
  };
}
