{
  config,
  pkgs,
  self,
  ...
}:
{
  imports = [
    ./appearance.nix
    ./containers
    ./presets/plasma
    ./programs
  ];

  hm.imports = [ self.hmModules.hm-plus ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  nix = {
    settings.extra-platforms = [ "aarch64-linux" ];
    daemonCPUSchedPolicy = "idle";
  };

  roles.base = {
    username = "leah";
    realName = "Leah";
    fullName = "Leah Amelia Chen";
    canSudo = true;
  };

  roles.email =
    let
      realName = config.roles.base.fullName;
      host = {
        imap = {
          host = "imap.migadu.com";
          port = 993;
        };
        smtp = {
          host = "smtp.migadu.com";
          port = 465;
        };
      };
    in
    {
      enable = true;
      accounts = {
        "hi@pluie.me" = {
          inherit realName host;
          primary = true;
        };
        "acc@pluie.me" = {
          inherit host;
          realName = "${realName} [accounts]";
        };
      };
    };

  roles.fish = {
    enable = true;
    defaultShell = true;
  };

  environment.variables = {
    NIXOS_OZONE_WL = "1";
    SDL_VIDEODRIVER = "wayland";
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443
      5173
    ];
  };

  services.cloudflare-warp.enable = true;

  nix.package = pkgs.lix;
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
}
