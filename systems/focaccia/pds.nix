{
  # inputs,
  config,
  # lib,
  # pkgs,
  ...
}:
{
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets.bluesky-pds = {
    sopsFile = ./secrets/bluesky-pds.env;
    format = "dotenv";
  };

  # TODO: replace with tranquil PDS once i had more time
  services.bluesky-pds = {
    enable = true;
    environmentFiles = [ config.sops.secrets.bluesky-pds.path ];
    settings = {
      PDS_HOSTNAME = "pds.pluie.me";
      PDS_PORT = 11037;
    };
  };

  # services.postgresql = {
  #   enable = true;
  #   authentication = ''
  #     host all postgres samehost trust
  #   '';
  #   ensureDatabases = [ "pds" ];
  # };

  # users.users.pds = {
  #   group = "pds";
  #   isSystemUser = true;
  # };

  # users.groups.pds = { };

  # systemd.services.tranquil-pds = {
  #   description = "Tranquil PDS";

  #   after = [ "network-online.target" ];
  #   wants = [ "network-online.target" ];
  #   wantedBy = [ "multi-user.target" ];

  #   serviceConfig = {
  #     ExecStart =
  #       lib.getExe' inputs.tranquil-pds.packages.${pkgs.stdenv.hostPlatform.system}.default
  #         "tranquil-pds";

  #     Environment = lib.mapAttrsToList (k: v: "${k}=${toString v}") {
  #       PDS_HOSTNAME = "pds.pluie.me";
  #       SERVER_HOST = "127.0.0.1";
  #       SERVER_PORT = 11037;
  #       DATABASE_URL = "postgres://postgres:postgres@localhost:5432/pds";
  #     };

  #     EnvironmentFile = [ config.sops.secrets.tranquil-pds.path ];
  #     User = "pds";
  #     Group = "pds";
  #     StateDirectory = "pds";
  #     StateDirectoryMode = "0755";
  #     Restart = "always";

  #     # Hardening
  #     RemoveIPC = true;
  #     # CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
  #     NoNewPrivileges = true;
  #     PrivateDevices = true;
  #     ProtectClock = true;
  #     ProtectKernelLogs = true;
  #     ProtectControlGroups = true;
  #     ProtectKernelModules = true;
  #     PrivateMounts = true;
  #     SystemCallArchitectures = [ "native" ];
  #     MemoryDenyWriteExecute = false; # required by V8 JIT
  #     RestrictNamespaces = true;
  #     RestrictSUIDSGID = true;
  #     ProtectHostname = true;
  #     LockPersonality = true;
  #     ProtectKernelTunables = true;
  #     RestrictAddressFamilies = [
  #       "AF_UNIX"
  #       "AF_INET"
  #       "AF_INET6"
  #     ];
  #     RestrictRealtime = true;
  #     DeviceAllow = [ "" ];
  #     ProtectSystem = "strict";
  #     ProtectProc = "invisible";
  #     ProcSubset = "pid";
  #     ProtectHome = true;
  #     PrivateUsers = true;
  #     PrivateTmp = true;
  #     UMask = "0077";
  #   };
  # };
}
