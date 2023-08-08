{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption mkIf types;
  user = config.pluie.user;
in {
  options.pluie.user = {
    name = mkOption {
      type = types.nullOr types.str;
      description = "The user's name.";
    };
    realName = mkOption {
      type = types.nullOr types.str;
      description = "The user's real name.";
    };
    fullName = mkOption {
      type = types.nullOr types.str;
      description = "The user's full name";
    };
    config = mkOption {
      type = types.nullOr types.attrs;
      description = "The user's configs.";
    };
    modules = mkOption {
      type = types.listOf types.path;
      description = "Modules.";
    };
  };

  config = mkIf (user.name != null && user.config != null) {
    home-manager.users.${user.name} =
      {
        imports = user.modules;
        _module.args = {inherit user;};

        home.username = user.name;
        home.homeDirectory = "/home/${user.name}";

        # This value determines the Home Manager release that your configuration is
        # compatible with. This helps avoid breakage when a new Home Manager release
        # introduces backwards incompatible changes.
        #
        # You should not change this value, even if you update Home Manager. If you do
        # want to update the value, then make sure to first check the Home Manager
        # release notes.
        home.stateVersion = "23.05"; # Please read the comment before changing.

        programs.home-manager.enable = true;
        xdg.enable = true;
      }
      // user.config;
  };
}
