{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption mkIf mkMerge types;
  user = config.pluie.user;
in {
  imports = [
    ./ime
    ./email.nix
  ];

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

  config = mkMerge [
    {
      pluie.user.ime = lib.mkDefault rec {
        enabled = "fcitx5";
        engines = ["rime" "mozc"];

        fcitx5.profile.groups = [
          {
            name = "Default";
            defaultLayout = "us";
            defaultIM = "keyboard-us";
            items = map (name: {inherit name;}) (["keyboard-us"] ++ engines);
          }
        ];
      };
    }
    (mkIf (user.name != null) {
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
            imports = user.modules;
            _module.args = {inherit user;};

            home.username = user.name;
            home.homeDirectory =
              if (user.name != null)
              then "/home/${user.name}"
              else null;

            # This value determines the Home Manager release that your configuration is
            # compatible with. This helps avoid breakage when a new Home Manager release
            # introduces backwards incompatible changes.
            #
            # You should not change this value, even if you update Home Manager. If you do
            # want to update the value, then make sure to first check the Home Manager
            # release notes.
            home.stateVersion = "23.05"; # Please read the comment before changing.

            programs.home-manager.enable = true;
          }
          user.config
        ];
      };
    })
  ];
}
