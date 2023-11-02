{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.roles.mirrors;
  defaultSite = cfg.chinese.sites.${cfg.chinese.defaultSite};
in {
  options.roles.mirrors.chinese = {
    enable = mkEnableOption "Chinese mirror sites to speed up downloads in Mainland China";

    defaultSite = mkOption {
      type = types.str // {check = builtins.hasAttr cfg.chinese.sites;};

      default = "sjtu";
    };

    sites = mkOption {
      description = "A list of Chinese mirror sites to use.";
      type = types.attrsOf types.str;
      default = [
        {
          sjtu = "https://mirrors.sjtug.sjtu.edu.cn";
          tuna = "https://mirrors.tuna.tsinghua.edu.cn";
          ustc = "https://mirrors.ustc.edu.cn";
        }
      ];
    };
  };

  config = mkIf cfg.chinese.enable {
    roles.rust = {
      rust-bin =
        config.roles.rust.rust-bin
        // {
          distRoot = "${defaultSite}/rust-static/dist";
        };

      settings.source =
        {
          crates-io.replace-with = cfg.chinese.defaultSite;
        }
        // builtins.mapAttrs (_: url: "sparse+${url}/crates.io-index") cfg.chinese.sites;
    };

    # cache.nixos.org is *unbearably* slow when accessed from Mainland China.
    # Fortunately, mirror sites exist... Hooray(?)
    nix.settings.substituters = map (url: "${url}/nix-channels/store") (builtins.attrValues cfg.chinese.sites);
  };
}
