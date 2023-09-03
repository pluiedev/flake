{
  config,
  lib,
  ...
}: let
  cfg = config.pluie.user.email;
  inherit (lib) mkEnableOption mkIf mkOption types;

  serverModule.options = {
    host = mkOption {
      type = types.str;
      example = "imap.migadu.com";
    };
    port = mkOption {
      type = types.port;
      example = 143;
    };
  };
  hostModule.options = {
    imap = mkOption {
      type = types.submodule serverModule;
      example = {
        host = "imap.migadu.com";
        port = 993;
      };
    };
    smtp = mkOption {
      type = types.submodule serverModule;
      example = {
        host = "smtp.migadu.com";
        port = 465;
      };
    };
  };
  emailModule.options = {
    primary = mkOption {
      type = types.bool;
      default = false;
      example = true;
    };
    realName = mkOption {
      type = types.str;
      example = "Leah";
    };
  };
in {
  options.pluie.user.email = {
    enable = mkEnableOption "E-Mail configurations";

    host = mkOption {
      type = types.submodule hostModule;
    };
    accounts = mkOption {
      type = types.attrsOf (types.submodule emailModule);
      default = {};
    };
  };

  config = mkIf cfg.enable {
    pluie.user.config.accounts.email.accounts =
      builtins.mapAttrs (address: account: rec {
        inherit (account) primary realName;
        inherit (cfg.host) imap smtp;
        inherit address;
        userName = address; # Use the address as the IMAP/SMTP username by default
        thunderbird.enable = true;
      })
      cfg.accounts;
  };
}
