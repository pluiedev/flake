{ config, lib, ... }:
let
  inherit (lib)
    mkAliasOptionModule
    mkEnableOption
    mkOption
    types
    optional
    ;

  cfg = config.roles.base;
in
{
  options.roles.base = {
    username = mkOption {
      type = types.str;
      example = "cavej";
      description = "The primary user's internal user name.";
    };
    realName = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "Cave";
      description = "The primary user's real name.";
    };
    fullName = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "Cave Johnson";
      description = "The primary user's full name.";
    };

    canSudo = mkEnableOption "admin permissions for the primary user";
  };

  imports = [
    (mkAliasOptionModule [ "hm" ] [
      "home-manager"
      "users"
      cfg.username
    ])
    (mkAliasOptionModule
      [
        "roles"
        "base"
        "user"
      ]
      [
        "users"
        "users"
        cfg.username
      ]
    )
  ];

  config = {
    assertions = [
      {
        assertion = builtins.hasAttr "username" cfg;
        message = "base role username has to be set";
      }
    ];

    nix.settings.trusted-users = optional cfg.canSudo cfg.username;

    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      useUserPackages = true;
    };

    hm = {
      home = {
        inherit (cfg) username;
        homeDirectory = config.roles.base.user.home;
      };

      programs.home-manager.enable = true;
    };
  };
}
