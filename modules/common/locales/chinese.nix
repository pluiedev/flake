{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.pluie.locales.chinese;
  inherit (lib) mkEnableOption mkIf;
in {
  options.pluie.locales.chinese.enable = mkEnableOption "Chinese locale";

  config = {
    time.timeZone = "Asia/Shanghai";

    # cache.nixos.org is *unbearably* slow when accessed from Mainland China.
    # Fortunately, mirror sites exist... Hooray(?)
    nix.settings.substituters = [
      "https://mirrors.sjtug.sjtu.edu.cn/nix-channels/store/"
      "https://mirrors.ustc.edu.cn/nix-channels/store/"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    ];

    # *even more audible sighs*
    pluie.tools.rust = {
      rust-bin = pkgs.rust-bin // {distRoot = "https://mirror.sjtu.edu.cn/rust-static/dist";};

      settings.source = {
        crates-io.replace-with = "sjtu";

        tuna.registry = "sparse+https://mirrors.tuna.tsinghua.edu.cn/crates.io-index/";
        ustc.registry = "sparse+https://mirrors.ustc.edu.cn/crates.io-index/";
        sjtu.registry = "sparse+https://mirrors.sjtug.sjtu.edu.cn/crates.io-index/";
      };
    };
  };
}
