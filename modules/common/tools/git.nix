{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.pluie.tools.git;
  user = config.pluie.user;
  primaryEmail = builtins.attrNames (lib.filterAttrs (_: v: v.primary) user.email.accounts);
in {
  options.pluie.tools.git = {
    enable = mkEnableOption "Git";

    signer = mkOption {
      type = types.nullOr types.path;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    pluie.user.config = {
      programs.git = {
        enable = true;
        userName = user.fullName;
        userEmail = mkIf (primaryEmail != []) (builtins.head primaryEmail);

        signing = {
          signByDefault = true;
          format = "ssh";
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC7uJGE2/25M4a3DIVxtnTA5INqWsFGw+49qHXaN/kqy";
          program = mkIf (cfg.signer != null) cfg.signer;
        };

        extraConfig.init.defaultBranch = "main";
      };

      programs.gh = {
        enable = true;
        settings.git_protocol = "ssh";
      };
    };
  };
}
