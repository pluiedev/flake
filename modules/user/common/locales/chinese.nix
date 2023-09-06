{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.pluie.user.locales.chinese;
in {
  options.pluie.user.locales.chinese.enable = mkEnableOption "Chinese locale";

  config = mkIf cfg.enable rec {
    home.language = {
      base = "en_US.UTF-8";
      ctype = "en_US.UTF-8";
      measurement = "zh_CN.UTF-8"; # Imperial measurements? I'd rather die :kek:
      paper = "zh_CN.UTF-8"; # Letter is literally used only in the US and Canada.
      monetary = "zh_CN.UTF-8";
      name = "zh_CN.UTF-8";
      numeric = "zh_CN.UTF-8";
      telephone = "zh_CN.UTF-8";
    };

    # Perl whines about this if not set
    home.sessionVariables = {
      LANGUAGE = home.language.base;
    };
  };
}
