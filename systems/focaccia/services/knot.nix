{
  inputs,
  config,
  ...
}:
let
  cfg = config.services.tangled.knot.server;
in
{
  imports = [
    

    inputs.tangled.nixosModules.knot
  ];

  services.tangled.knot = {
    enable = true;
    openFirewall = false;

    stateDir = "/var/lib/tangled-knot";
    server = {
      listenAddr = "0.0.0.0:8964";
      internalListenAddr = "127.0.0.1:4698";
      owner = "did:plc:e4f33w5yt2m54tq6vsagpwiu";
      hostname = "knot.pluie.me";
    };
  };
  services.caddy.virtualHosts.${cfg.hostname}.extraConfig = ''
    reverse_proxy :8964
  '';
}
