{
  config,
  lib,
  ...
}: let
  cfg = config.roles.email;
  inherit (lib) mkEnableOption mkIf mkOption types pipe;

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
    host = mkOption {
      type = types.submodule hostModule;
    };
  };
in {
  options.roles.email = {
    enable = mkEnableOption "E-Mail configurations";

    accounts = mkOption {
      type = types.attrsOf (types.submodule emailModule);
      default = {};
    };
  };

  config = let
    accounts' =
      builtins.mapAttrs (address: account: rec {
        inherit (account) primary realName;
        inherit (account.host) imap smtp;
        inherit address;
        userName = address; # Use the address as the IMAP/SMTP username by default
        thunderbird.enable = true;
      })
      cfg.accounts;
  in
    mkIf cfg.enable {
      hm.accounts.email.accounts = accounts';

      roles.git.email = let
        primary = pipe accounts' [
          (lib.filterAttrs (_: v: v.primary))
          builtins.attrValues
          (map (a: a.address))
        ];
      in
        mkIf (primary != [])
        (builtins.head primary);
    };
}
