{
  config,
  lib,
  pkgs,
  inputs',
  ...
}:
{
  hm.programs.firefox = {
    enable = true;

    profiles.${config.roles.base.username} = {
      isDefault = true;
      name = config.roles.base.realName;

      extensions =
        let
          # FIXME: firefox-addons currently receives free-only nixpkgs,
          # and so unfree plugins are blocked from evaluation.
          # Use this one dirty trick to make the FSF mad! :trolley:
          gaslight = pkgs: pkgs.overrideAttrs { meta.license.free = true; };
        in
        with inputs'.firefox-addons.packages;
        map gaslight [
          # Essentials
          auto-tab-discard
          onepassword-password-manager
          ublock-origin

          # Avoid annoyances
          consent-o-matic
          don-t-fuck-with-paste
          enhanced-h264ify
          fastforwardteam
          faststream
          gaoptout
          istilldontcareaboutcookies
          link-cleaner
          musescore-downloader
          native-mathml
          privacy-possum
          re-enable-right-click
          sponsorblock
          terms-of-service-didnt-read
          youtube-nonstop

          # Redirectors
          indie-wiki-buddy
          libredirect
          localcdn
          modrinthify

          # Augmentations
          augmented-steam
          github-file-icons
          octolinker
          protondb-for-steam
          refined-github
          widegithub
          wikiwand-wikipedia-modernized

          # Language
          furiganaize
          immersive-translate
          # languagetool

          # Styling
          darkreader
          firefox-color
          stylus

          # Dev
          a11ycss
          header-editor
          rust-search-extension

          disconnect
          pronoundb
          search-by-image
          unpaywall
          wayback-machine
        ];

      search =
        let
          mkParams = lib.mapAttrsToList lib.nameValuePair;
          nixIcon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          nixosSearch = path: aliases: {
            urls = [ { template = "https://nixpkgs.dev${path}/{searchTerms}"; } ];
            icon = nixIcon;
            definedAliases = aliases;
          };

          search = path: queryKey: {
            template = path;
            params = mkParams { ${queryKey} = "{searchTerms}"; };
          };
        in
        {
          default = "DuckDuckGo";
          force = true;
          engines = {
            "Nixpkgs" = nixosSearch "" [ "@np" ];
            "NixOS Options" = nixosSearch "/option" [
              "@ns"
              "@no"
            ];
            "NixOS Wiki" = {
              urls = [ (search "https://nixos.wiki/index.php" "search") ];
              icon = nixIcon;
              definedAliases = [ "@nw" ];
            };
            "Nixpkgs PR Tracker" = {
              urls = [ (search "https://nixpk.gs/pr-tracker.html" "pr") ];
              icon = nixIcon;
              definedAliases = [ "@npr" ];
            };
            "Home Manager Settings" = {
              urls = [ (search "https://home-manager-options.extranix.com" "query") ];
              icon = nixIcon;
              definedAliases = [ "@hm" ];
            };
            "Wiktionary" = {
              urls = [ (search "https://en.wiktionary.org/wiki/Special:Search" "search") ];
              icon = "https://en.wiktionary.org/favicon.ico";
              definedAliases = [ "@wkt" ];
            };
            "GitHub" = {
              urls = [ (search "https://github.com/search" "q") ];
              icon = "https://github.com/favicon.ico";
              definedAliases = [ "@gh" ];
            };
            "docs.rs" = {
              urls = [ (search "https://docs.rs/releases/search" "query") ];
              icon = "https://docs.rs/-/static/favicon.ico";
              definedAliases = [ "@rs" ];
            };
            "lib.rs" = {
              urls = [ (search "https://lib.rs/search" "q") ];
              icon = "https://lib.rs/favicon.ico";
              definedAliases = [ "@lrs" ];
            };
          };
        };
    };
  };
}
