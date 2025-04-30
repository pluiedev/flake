# Common configs for all users.
{
  inputs,
  ...
}:
{
  imports = [
    inputs.hjem.nixosModules.hjem
  ];

  hjem.clobberByDefault = true;

  hjem.extraModules = [
    inputs.hjem-rum.hjemModules.default
    inputs.self.hjemModules.hjem-ext
    inputs.self.hjemModules.hjem-ctp
  ];
}
