{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) getExe getExe' mkIf mkOption types;
  cfg = config.programs.git;
in {
  options.programs.git = {
    signingFormat = mkOption {
      type = types.enum ["openpgp" "ssh" "x509"];
      default = "openpgp";
    };

    signer = mkOption {
      type = types.path;
      default =
        {
          openpgp = getExe' pkgs.gnupg "gpg2";
          ssh = getExe pkgs.openssh;
          x509 = getExe' pkgs.gnupg "gpgsm";
        }
        .${cfg.signingFormat};
    };
  };
  config = mkIf cfg.enable {
    programs.git.extraConfig.gpg = {
      format = cfg.signingFormat;
      ${cfg.signingFormat}.program = cfg.signer;
    };
  };
}
