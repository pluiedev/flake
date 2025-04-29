{
  config,
  pkgs,
  self,
  ...
}:
{
  imports = [
    ./appearance.nix
    ./presets/plasma
    ./programs
  ];

  hm.imports = [ self.hmModules.hm-plus ];

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    kernelParams = [ "plymouth.use-simpledrm" ];
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
  };

  nix = {
    settings.extra-platforms = [ "aarch64-linux" ];
    daemonCPUSchedPolicy = "idle";
  };

  i18n.supportedLocales = [ "all" ];

  roles.base = {
    username = "leah";
    realName = "Leah";
    fullName = "Leah Amelia Chen";
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC7uJGE2/25M4a3DIVxtnTA5INqWsFGw+49qHXaN/kqy";
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
}
