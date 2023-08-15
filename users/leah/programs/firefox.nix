{
  user,
  lib,
  pkgs,
  ...
}: let
  mkParams = lib.mapAttrsToList lib.nameValuePair;
in {
  programs.firefox = {
    enable = true;
    # Janky workaround
    # https://github.com/nix-community/home-manager/issues/1586
    package = pkgs.firefox.override {
      cfg.enablePlasmaBrowserIntegration = true;
    };

    profiles.${user.name} = {
      isDefault = true;
      name = user.realName;

      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        augmented-steam
        auto-tab-discard
        darkreader
        decentraleyes
        disconnect
        furiganaize
        languagetool
        onepassword-password-manager
        plasma-integration
        pronoundb
        protondb-for-steam
        refined-github
        rust-search-extension
        search-by-image
        sponsorblock
        terms-of-service-didnt-read
        ublock-origin
        unpaywall
        vencord-web
        wayback-machine
        youtube-nonstop
      ];

      search = let
        nixosSearch = path: aliases: {
          urls = [
            {
              template = "https://search.nixos.org/${path}";
              params = mkParams {
                type = "packages";
                channel = "unstable";
                sort = "relevance";
                query = "{searchTerms}";
              };
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = aliases;
        };
      in {
        default = "DuckDuckGo";
        force = true;
        engines = {
          "Nix Packages" = nixosSearch "packages" ["@np"];
          "NixOS Settings" = nixosSearch "options" ["@ns"];
          "NixOS Wiki" = {
            urls = [
              {
                template = "https://nixos.wiki/index.php";
                params = mkParams {search = "{searchTerms}";};
              }
            ];
            iconUpdateURL = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = ["@nw"];
          };
          "Wiktionary" = {
            urls = [
              {
                template = "https://en.wiktionary.org/wiki/Special:Search";
                params = mkParams {search = "{searchTerms}";};
              }
            ];
            icon = "https://en.wiktionary.org/favicon.ico";
            definedAliases = ["@wkt"];
          };
        };
      };
    };
  };
}
