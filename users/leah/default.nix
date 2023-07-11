{pkgs, ...}: {
  users.users.leah = {
    isNormalUser = true;
    description = "Leah";
    extraGroups = [
      "networkmanager"
      "wheel" # `sudo` powers
    ];
    shell = pkgs.fish;
  };

  programs = {
    fish.enable = true;
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = ["leah"];
    };
  };

  # Je suis chinoise
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-rime
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.leah.imports = [
      ./home.nix
    ];
  };
}
