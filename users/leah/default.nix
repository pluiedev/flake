{
  config,
  inputs,
  ...
}:
{
  imports = [
    ./appearance.nix
    # ./presets/plasma
    ./programs

    inputs.hjem.nixosModules.hjem
    inputs.nix-index-database.nixosModules.nix-index
  ];

  hjem.extraModules = [
    inputs.hjem-rum.hjemModules.default
  ];

  i18n.supportedLocales = [ "all" ];

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

  hjem.clobberByDefault = true;
}
