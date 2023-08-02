{
  personal = inputs @ {
    name,
    nixpkgs,
    nur,
    rust-overlay,
    home-manager,
    ragenix,
    ...
  }: {
    system = "x86_64-linux";
    builder = nixpkgs.lib.nixosSystem;

    modules = [
      ./${name}

      home-manager.nixosModules.home-manager
      nur.nixosModules.nur
      ragenix.nixosModules.default

      ../users/leah
      ./fix-246195.nix

      {
        networking.hostName = name;
        system.stateVersion = "23.11";

        home-manager = {
          backupFileExtension = "backup";
          useGlobalPkgs = true;
          useUserPackages = true;
        };

        nixpkgs = {
          overlays = [nur.overlay rust-overlay.overlays.default];
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
