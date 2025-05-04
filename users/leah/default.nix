{ inputs, config, ... }:
{
  imports = [
    ../common.nix
    ./appearance.nix
    # ./presets/plasma
    ./presets/niri
    ./programs

    inputs.hjem.nixosModules.hjem
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

    # FIXME: huge fucking hack
    # Why isn't this working? who knows
    packages = config.hjem.users.leah.packages;
  };

  # Name and directory should be populated by users.users
  hjem.users.leah.enable = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [
      "zh_CN.UTF-8"
      "de_DE.UTF-8"
    ];
    extraLocaleSettings.LC_TIME = "de_DE.UTF-8";
  };
}
