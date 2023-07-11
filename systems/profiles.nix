{
  personal = name: inputs @ {
    nixpkgs,
    nur,
    home-manager,
    ...
  }: {
    system = "x86_64-linux";
    builder = nixpkgs.lib.nixosSystem;

    modules = [
      ./${name}

      home-manager.nixosModules.home-manager
      nur.nixosModules.nur

      ../users/leah

      {
        networking.hostName = name;
        system.stateVersion = "23.11";

        nixpkgs = {
          overlays = [nur.overlay];
          config.allowUnfree = true;
        };

        nix = {
          registry = let
            nixpkgsRegistry.flake = nixpkgs;
          in {
            nixpkgs = nixpkgsRegistry;
            n = nixpkgsRegistry;
          };
          gc = {
            automatic = true;
            dates = "3d";
            options = "-d";
          };
          settings = {
            auto-optimise-store = true;
            experimental-features = ["nix-command" "flakes"];

            # Certainly a China moment
            substituters = ["https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"];
          };
        };
      }
    ];
    specialArgs = inputs;
  };
}
