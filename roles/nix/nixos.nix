{
  self,
  config,
  pkgs,
  lib,
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

    configurationRevision = self.rev or self.dirtyRev or "unknown-dirty";
  };
}
