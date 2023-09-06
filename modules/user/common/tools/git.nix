{
  config,
  lib,
  user,
  ...
}: let
  inherit (lib) filterAttrs mkEnableOption mkOption mkIf types;
  cfg = config.pluie.user.tools.git;
in {
  options.pluie.user.tools.git = {
    enable = mkEnableOption "Git";

    name = mkOption {
      type = types.nullOr types.str;
      default = user.fullName;
    };

    email = mkOption {
      type = types.nullOr types.str;

      default = let
        primaryEmail = builtins.attrNames (filterAttrs (_: v: v.primary) config.accounts.email.accounts);
      in
        if primaryEmail != []
        then builtins.head primaryEmail
        else null;
    };

    signer = mkOption {
      type = types.nullOr types.path;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = mkIf (cfg.name != null) cfg.name;
      userEmail = mkIf (cfg.email != null) cfg.email;

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
}
