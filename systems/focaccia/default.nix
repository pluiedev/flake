{
  ...
}:
{
  imports = [
    ../common.nix
    ./hardware-configuration.nix
    ./networking.nix
  ];

  networking.hostName = "focaccia";
  networking.domain = "";

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
}
