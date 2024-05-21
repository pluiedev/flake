{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkIf
    mkOption
    mkEnableOption
    mkPackageOption
    optional
    getExe'

    flatten
    mapAttrsToList
    nameValuePair
    listToAttrs
    ;

  inherit (builtins) isAttrs concatStringsSep;

  cfg = config.programs._1password;

  format = pkgs.formats.json { };

  # Converts an attrset like { p = 4; a.b.c = { d.e.f = 3; e = 5; }; }
  # to another attrset like { p = 4; "a.b.c.d.e.f" = 3; "a.b.c.e" = 5; }
  pathify =
    let
      pathify' =
        path: v:
        if isAttrs v then
          flatten (mapAttrsToList (n: pathify' (path ++ [ n ])) v)
        else if path == [ ] then
          throw "Attempted to pathify something that's not an attrset: ${toString v}"
        else
          [ (nameValuePair (concatStringsSep "." path) v) ];
    in
    v: listToAttrs (pathify' [ ] v);
in
{
  options.programs._1password = {
    enable = mkEnableOption "1Password";

    package = mkPackageOption pkgs "1Password" { default = [ "_1password-gui" ]; };

    autostart = mkEnableOption "autostarting 1Password";

    settings = mkOption {
      inherit (format) type;
      default = { };
      description = ''
        Configuration written to {file}`$XDG_CONFIG_HOME/1Password/settings/settings.json`.

        Note that setting `sshAgent.enabled` in these settings also enables the 1Password SSH agent automatically.
      '';
    };

    sshAgent.enable = mkEnableOption "1Password's SSH agent";
  };
  config = mkIf cfg.enable {
    home.packages =
      [ cfg.package ]
      ++ optional cfg.autostart (
        pkgs.makeAutostartItem {
          name = "1password";
          inherit (cfg) package;
        }
      );

    xdg.configFile."1Password/settings/settings.json".source =
      format.generate "1password-settings.json"
        (pathify ({ version = 1; } // cfg.settings));

    programs = mkIf cfg.sshAgent.enable {
      _1password.settings.sshAgent.enabled = true;

      git.signer = getExe' cfg.package "op-ssh-sign";
      ssh.enable = mkDefault true;
      ssh.extraConfig = "IdentityAgent ${config.home.homeDirectory}/.1password/agent.sock";
    };
  };
}
