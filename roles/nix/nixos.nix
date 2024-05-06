{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  system = {
    # Thank @luishfonseca for this
    # https://github.com/luishfonseca/dotfiles/blob/ab7625ec406b48493eda701911ad1cd017ce5bc1/modules/upgrade-diff.nix
    activationScripts.diff = {
      supportsDryActivation = true;
      text = ''
        ${lib.getExe pkgs.nvd} --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
      '';
    };

    # thanks to @getchoo
    autoUpgrade = {
      enable = true;
      flake = "github:pluiedev/flake#${config.networking.hostName}";
      flags = ["--refresh"];
    };

    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or "unknown-dirty";
  };
}
