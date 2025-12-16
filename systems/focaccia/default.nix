{
  lib,
  utils,
  ...
}:
let
  settings = {

  };
in
{
  imports = [
    ../common.nix
    ./hardware-configuration.nix
    ./networking.nix
    ../../modules/nixos/hysteria.nix
  ];

  networking = {
    hostName = "focaccia";
    domain = "pluie.me";
    firewall = {
      allowedUDPPorts = [ 53 ];
      allowedTCPPorts = [
        80
        443
      ];
    };
  };

  users.users.leah = {
    enable = true;
    isNormalUser = true;
    description = "Leah C";
    extraGroups = [
      "wheel" # 1984 powers
    ];
    home = "/home/leah";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKbsavGX9rGRx5R+7ovLn+r7D/w3zkbqCik4bS31moSz"
    ];
  };

  services.openssh = {
    enable = true;
    ports = [ 42069 ];
    settings.PermitRootLogin = "prohibit-password";
  };

  programs.mosh = {
    enable = true;
    openFirewall = true;
  };

  users.users.root.openssh.authorizedKeys.keys = [
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKbsavGX9rGRx5R+7ovLn+r7D/w3zkbqCik4bS31moSz''
  ];

  boot.kernel.sysctl = {
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;
  };

  services.hysteria = {
    enable = true;
    settings = {
      listen = ":53";
      acme = {
        domains = [ "focaccia.pluie.me" ];
        email = "srv@acc.pluie.me";
      };
      auth = {
        type = "password";
        password._secret = "/var/lib/hysteria/passwd";
      };
      masquerade = {
        type = "proxy";
        proxy = {
          url = "https://news.ycombinator.com/";
          rewriteHost = true;
        };
      };
    };
  };
}
