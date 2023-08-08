{
  config,
  lib,
  ...
}: let
  cfg = config.pluie.locales.chinese;
  inherit (lib) mkEnableOption mkIf;
in {
  options.pluie.locales.chinese.enable = mkEnableOption "Chinese locale";

  config = mkIf cfg.enable {
    time.timeZone = "Asia/Shanghai";

    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_MEASUREMENT = "zh_CN.UTF-8"; # Imperial measurements? I'd rather die :kek:
      LC_PAPER = "zh_CN.UTF-8"; # Letter is literally used only in the US and Canada.
      LC_MONETARY = "zh_CN.UTF-8";
      LC_NAME = "zh_CN.UTF-8";
      LC_NUMERIC = "zh_CN.UTF-8";
      LC_TELEPHONE = "zh_CN.UTF-8";
    };

    # cache.nixos.org is *unbearably* slow when accessed from Mainland China.
    # Fortunately, mirror sites exist... Hooray(?)
    nix.settings.substituters = ["https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"];
  };
}
