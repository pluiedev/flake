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
        nixIcon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
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
          icon = nixIcon;
          definedAliases = aliases;
        };

        search = path: queryKey: {
          template = path;
          params = mkParams {${queryKey} = "{searchTerms}";};
        };
      in {
        default = "DuckDuckGo";
        force = true;
        engines = {
          "Nixpkgs" = nixosSearch "packages" ["@np"];
          "NixOS Settings" = nixosSearch "options" ["@ns"];
          "NixOS Wiki" = {
            urls = [(search "https://nixos.wiki/index.php" "search")];
            icon = "https://nixos.wiki/favicon.png";
            definedAliases = ["@nw"];
          };
          "Nixpkgs PR Tracker" = {
            urls = [(search "https://nixpk.gs/pr-tracker.html" "pr")];
            icon = nixIcon;
            definedAliases = ["@npr"];
          };
          "Home Manager Settings" = {
            urls = [(search "https://mipmip.github.io/home-manager-option-search/" "query")];
            icon = nixIcon;
            definedAliases = ["@hm"];
          };
          "Wiktionary" = {
            urls = [(search "https://en.wiktionary.org/wiki/Special:Search" "search")];
            icon = "https://en.wiktionary.org/favicon.ico";
            definedAliases = ["@wkt"];
          };
          "GitHub" = {
            urls = [(search "https://github.com/search" "q")];
            icon = "https://github.com/favicon.ico";
            definedAliases = ["@gh"];
          };
          "docs.rs" = {
            urls = [(search "https://docs.rs/releases/search" "query")];
            icon = "https://docs.rs/-/static/favicon.ico";
            definedAliases = ["@rs"];
          };
          "lib.rs" = {
            urls = [(search "https://lib.rs/search" "q")];
            icon = "https://lib.rs/favicon.ico";
            definedAliases = ["@lrs"];
          };
        };
      };
    };
  };
}
