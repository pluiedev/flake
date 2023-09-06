{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption mkIf mkMerge types;
  user = config.pluie.user;
in {
  options.pluie.user = {
    name = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "The user's name.";
    };
    realName = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "The user's real name.";
    };
    fullName = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "The user's full name";
    };
    homeDirectory = mkOption {
      type = types.nullOr types.str;
      default =
        if (user.name != null)
        then "/home/${user.name}"
        else null;
      description = "The user's home directory.";
    };
    canSudo = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Whether the user can run sudo.";
    };
    config = mkOption {
      type = types.attrsOf types.anything;
      default = {};
      description = "The user's configs.";
    };
    modules = mkOption {
      type = types.listOf types.anything;
      default = [];
      description = "Modules.";
    };
  };

  config = mkIf (user.name != null) {
    users.users.${user.name} = {
      isNormalUser = true;
      description = user.realName;
      extraGroups = lib.optional user.canSudo "wheel";
    };

    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      useUserPackages = true;

      users.${user.name} = lib.mkMerge [
        {
          imports =
            [
              ./desktop
              ./email.nix
              ./locales
              ./tools
            ]
            ++ user.modules;
          _module.args = {inherit user;};

          home.username = user.name;
          home.homeDirectory = user.homeDirectory;
          home.stateVersion = "23.05";

          programs.home-manager.enable = true;
          xdg.enable = true;
        }
        user.config
      ];
    };
  };
}
