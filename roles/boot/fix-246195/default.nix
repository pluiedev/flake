{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.boot.loader.systemd-boot;
  python3 = pkgs.python3.withPackages (ps: [ps.packaging]);

  systemdBootBuilder = pkgs.substituteAll {
    src = ./systemd-boot-builder.py;

    isExecutable = true;
    inherit python3;
    systemd = config.systemd.package;
    nix = config.nix.package.out;
    timeout = optionalString (config.boot.loader.timeout != null) config.boot.loader.timeout;
    editor =
      if cfg.editor
      then "True"
      else "False";
    configurationLimit =
      if cfg.configurationLimit != null
      then cfg.configurationLimit
      else 0;

    inherit (cfg) consoleMode graceful;
    inherit (config.boot.loader.efi) efiSysMountPoint canTouchEfiVariables;
    inherit (config.system.nixos) distroName;

    memtest86 = optionalString cfg.memtest86.enable pkgs.memtest86-efi;
    netbootxyz = optionalString cfg.netbootxyz.enable pkgs.netbootxyz-efi;

    copyExtraFiles = pkgs.writeShellScript "copy-extra-files" ''
      empty_file=$(${pkgs.coreutils}/bin/mktemp)

      ${concatStrings (mapAttrsToList (n: v: ''
          ${pkgs.coreutils}/bin/install -Dp "${v}" "${efiSysMountPoint}/"${escapeShellArg n}
          ${pkgs.coreutils}/bin/install -D $empty_file "${efiSysMountPoint}/efi/nixos/.extra-files/"${escapeShellArg n}
        '')
        cfg.extraFiles)}

      ${concatStrings (mapAttrsToList (n: v: ''
          ${pkgs.coreutils}/bin/install -Dp "${pkgs.writeText n v}" "${efiSysMountPoint}/loader/entries/"${escapeShellArg n}
          ${pkgs.coreutils}/bin/install -D $empty_file "${efiSysMountPoint}/efi/nixos/.extra-files/loader/entries/"${escapeShellArg n}
        '')
        cfg.extraEntries)}
    '';
  };

  checkedSystemdBootBuilder =
    pkgs.runCommand "systemd-boot" {
      nativeBuildInputs = [pkgs.mypy python3];
    } ''
      install -m755 ${systemdBootBuilder} $out
      mypy \
        --no-implicit-optional \
        --disallow-untyped-calls \
        --disallow-untyped-defs \
        $out
    '';

  finalSystemdBootBuilder = pkgs.writeScript "install-systemd-boot.sh" ''
    #!${pkgs.runtimeShell}
    ${checkedSystemdBootBuilder} "$@"
    ${cfg.extraInstallCommands}
  '';
in {
  config = lib.mkIf config.roles.boot.patch.fix-246195.enable {
    system.build.installBootLoader = lib.mkForce finalSystemdBootBuilder;
  };
}
