{
  containers.postgres = {
    autoStart = true;
    config = {
      config,
      pkgs,
      lib,
      ...
    }: {
      services.postgresql = {
        enable = true;
        ensureDatabases = ["postgres"];
        authentication = ''
          # TYPE  DATABASE  USER  ADDRESS    METHOD
          host    all       all   localhost  trust
        '';
      };

      system.stateVersion = "24.05";
    };
  };
}
