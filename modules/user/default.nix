{lib, ...}: {
  imports = [
    ./ime
    ./hm-shim.nix
    ./email.nix
  ];

  config.pluie.user.ime = lib.mkDefault rec {
    enabled = "fcitx5";
    engines = ["rime" "mozc"];

    fcitx5.profile.groups = [
      {
        name = "Default";
        defaultLayout = "us";
        defaultIM = "keyboard-us";
        items = map (name: {inherit name;}) (["keyboard-us"] ++ engines);
      }
    ];
  };
}
