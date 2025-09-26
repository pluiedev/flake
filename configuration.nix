{ config, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect
    
  ];

  networking.hostName = "focaccia";

  #boot.kernelParams = [ "ip=1.2.3.4::1.2.3.1:255.255.255.192:myhostname:enp35s0:off" ];
  #networking = {
  #  useDHCP = false;
  #  interfaces."enp35s0" = {
  #    ipv4.addresses = [{ address = "1.2.3.4"; prefixLength = 26; }];
  #    ipv6.addresses = [{ address = "2a01:xx:xx::1"; prefixLength = 64; }];
  #  };
  #  defaultGateway = "1.2.3.1";
  #  defaultGateway6 = { address = "fe80::1"; interface = "enp35s0"; };
  #};

  networking.firewall.allowedTCPPorts = [8000] ++ config.services.openssh.ports;

  #services.openssh = {
  #  enable = true;
  #};
}
