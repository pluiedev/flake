{
  inputs,
  ...
}:
{
  imports = [
    ../common.nix
    ./hardware-configuration.nix
    ./networking.nix
    ../../modules/nixos/hysteria.nix # TODO: move out
    inputs.sops-nix.nixosModules.sops

    ./services/hysteria.nix
    ./services/knot.nix
    ./services/pds.nix
  ];

  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    defaultSopsFile = ./secrets/global.yaml;
  };

  networking = {
    hostName = "focaccia";
    domain = "pluie.me";
    firewall = {
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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINcpWY17MNJBx56APRSvLOfUjHllXn9gY/cV51JaLoh6"
    ];
  };

  services.openssh = {
    enable = true;
    ports = [ 42069 ];
    settings.PermitRootLogin = "prohibit-password";
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKbsavGX9rGRx5R+7ovLn+r7D/w3zkbqCik4bS31moSz"
  ];

  # Reverse proxy
  services.caddy = {
    enable = true;
    email = "srv@acc.pluie.me";
  };
 }
