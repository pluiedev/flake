{ config, lib, pkgs, ...}:

with lib;

let
  cfg = config.boot.loader.systemd-boot;
  efi = config.boot.loader.efi;
  python3 = pkgs.python3.withPackages (ps: [ ps.packaging ]);
  systemdBootBuilder = pkgs.substituteAll {
    src = ./systemd-boot-builder.py;
    isExecutable = true;
    inherit python3;
    systemd = config.systemd.package;
    nix = config.nix.package.out;
    timeout = optionalString (config.boot.loader.timeout != null) config.boot.loader.timeout;
    editor = if cfg.editor then "True" else "False";
    configurationLimit = if cfg.configurationLimit == null then 0 else cfg.configurationLimit;

    inherit (cfg) consoleMode graceful;
    inherit (efi) efiSysMountPoint canTouchEfiVariables;
    inherit (config.system.nixos) distroName;

    memtest86 = optionalString cfg.memtest86.enable pkgs.memtest86-efi;
    netbootxyz = optionalString cfg.netbootxyz.enable pkgs.netbootxyz-efi;

    copyExtraFiles = pkgs.writeShellScript "copy-extra-files" ''
      empty_file=$(${pkgs.coreutils}/bin/mktemp)

      ${concatStrings (mapAttrsToList (n: v: ''
        ${pkgs.coreutils}/bin/install -Dp "${v}" "${efi.efiSysMountPoint}/"${escapeShellArg n}
        ${pkgs.coreutils}/bin/install -D $empty_file "${efi.efiSysMountPoint}/efi/nixos/.extra-files/"${escapeShellArg n}
      '') cfg.extraFiles)}

      ${concatStrings (mapAttrsToList (n: v: ''
        ${pkgs.coreutils}/bin/install -Dp "${pkgs.writeText n v}" "${efi.efiSysMountPoint}/loader/entries/"${escapeShellArg n}
        ${pkgs.coreutils}/bin/install -D $empty_file "${efi.efiSysMountPoint}/efi/nixos/.extra-files/loader/entries/"${escapeShellArg n}
      '') cfg.extraEntries)}
    '';
  };

  checkedSystemdBootBuilder = pkgs.runCommand "systemd-boot" {
    nativeBuildInputs = [ pkgs.mypy python3 ];
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
  system.build.installBootLoader = lib.mkForce finalSystemdBootBuilder;
} 
