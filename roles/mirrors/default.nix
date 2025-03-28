{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.roles.mirrors;
in
{
  options.roles.mirrors.chinese = {
    enable = mkEnableOption "Chinese mirror sites to speed up downloads in Mainland China";

    sites = mkOption {
      description = "A list of Chinese mirror sites to use.";
      type = types.listOf types.str;
      default = [
        "https://mirrors.ustc.edu.cn"
        "https://mirrors6.tuna.tsinghua.edu.cn"
        "https://mirrors.tuna.tsinghua.edu.cn"
        # "https://mirror.sjtu.edu.cn"
      ];
    };
  };

  config = mkIf cfg.chinese.enable {
    # cache.nixos.org is *unbearably* slow when accessed from Mainland China.
    # Fortunately, mirror sites exist... Hooray(?)
    nix.settings.substituters = map (url: "${url}/nix-channels/store") cfg.chinese.sites;
  };
}
