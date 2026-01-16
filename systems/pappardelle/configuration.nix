{
  inputs,
  ...
}:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    ../laptop.nix
    ./hardware-configuration.nix
    lenovo-ideapad-14iah10
  ];

  hardware.bluetooth.enable = true;
  networking.hostName = "pappardelle";
  users.users.leah.enable = true;
}
