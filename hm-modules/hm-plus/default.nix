{ inputs' }: {
  imports = [
    ./programs
  ];
  _module.args = { inherit inputs'; };
}
