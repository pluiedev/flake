{pkgs, ...}: {
  imports = [
    ./shell.nix
  ];

  users.users.leah = {
    isNormalUser = true;
    description = "Leah";
    extraGroups = [
      "networkmanager"
      "wheel" # `sudo` powers
    ];
  };

  programs = {
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = ["leah"];
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
    xwayland.enable = true;
  };

  time.timeZone = "Asia/Shanghai";

  # Je suis chinoise
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-rime
    ];
  };
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  home-manager = {
    users.leah.imports = [
      ./home.nix
    ];
  };
}
