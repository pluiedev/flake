{
  config,
  lib,
  pkgs,
  nur,
  ...
}: {
  imports = [nur.nixosModules.nur];

  hm.programs.firefox = {
    enable = true;

    profiles.${config.roles.base.username} = {
      isDefault = true;
      name = config.roles.base.realName;

      # HiDPI shenanigans
      settings."layout.css.devPixelsPerPx" = 2;

      extensions = with config.nur.repos.rycee.firefox-addons; [
        augmented-steam
        auto-tab-discard
        darkreader
        decentraleyes
        disconnect
        firefox-color
        furiganaize
        languagetool
        onepassword-password-manager
        pronoundb
        protondb-for-steam
        refined-github
        rust-search-extension
        search-by-image
        sponsorblock
        terms-of-service-didnt-read
        ublock-origin
        unpaywall
        wayback-machine
        youtube-nonstop
      ];

      search = let
        mkParams = lib.mapAttrsToList lib.nameValuePair;
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
          "Nixpkgs" = nixosSearch "packages" ["@np"];
          "NixOS Settings" = nixosSearch "options" ["@ns"];
          "NixOS Wiki" = {
            urls = [
              {
                template = "https://nixos.wiki/index.php";
                params = mkParams {search = "{searchTerms}";};
              }
            ];
            icon = "https://nixos.wiki/favicon.png";
            definedAliases = ["@nw"];
          };
          "Nixpkgs PR Tracker" = {
            urls = [
              {
                template = "https://nixpk.gs/pr-tracker.html";
                params = mkParams {pr = "{searchTerms}";};
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@npr"];
          };
          "Home Manager Settings" = {
            urls = [
              {
                template = "https://mipmip.github.io/home-manager-option-search/";
                params = mkParams {query = "{searchTerms}";};
              }
            ];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@hm"];
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
          "GitHub" = {
            urls = [
              {
                template = "https://github.com/search";
                params = mkParams {q = "{searchTerms}";};
              }
            ];
            icon = "https://github.com/favicon.ico";
            definedAliases = ["@gh"];
          };
        };
      };
    };
  };
}
