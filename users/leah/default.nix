{
  imports = [
    ../common.nix
    ./appearance.nix
    # ./presets/plasma
    ./programs
  ];

  users.users.leah = {
    isNormalUser = true;
    description = "Leah C";
    extraGroups = [
      "wheel" # 1984 powers
      "rtkit" # Some apps may need to adjust audio priority at runtime
      "networkmanager" # Manage networks
    ];
    home = "/home/leah";
  };

  # Name and directory should be populated by users.users
  hjem.users.leah.enable = true;
}
