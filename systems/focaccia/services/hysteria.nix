{
  config,
  ...
}:
{
  sops.secrets.hysteria = { };

  networking.firewall.allowedUDPPorts = [ 53 ];

  services.hysteria = {
    enable = true;
    settings = {
      listen = ":53";
      acme = {
        domains = [ "focaccia.pluie.me" ];
        email = "srv@acc.pluie.me";
      };
      auth = {
        type = "password";
        password._secret = config.sops.secrets.hysteria.path;
      };
      masquerade = {
        type = "proxy";
        proxy = {
          url = "https://news.ycombinator.com/";
          rewriteHost = true;
        };
      };
    };
  };

  # CPU scheduling optimization for faster speeds :rocket:
  boot.kernel.sysctl = {
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;
  };
}
