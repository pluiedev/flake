{
  lib,
  pkgs,
  ...
}:
let
  json = pkgs.formats.json { };
  wrappedFirefox = pkgs.firefox.override {
    extraPoliciesFiles = [ (json.generate "firefox-policies.json" policies) ];
  };

  addons = [
    # Styling
    "addon@darkreader.org" # Dark Reader
    "{85860b32-02a8-431a-b2b1-40fbd64c9c69}" # File Icons for Git{Hub,Lab}
    "FirefoxColor@mozilla.com" # Firefox Color
    "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" # Stylus
    "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" # Refined GitHub
    "{72742915-c83b-4485-9023-b55dc5a1e730}" # Wide GitHub

    # Privacy
    "gdpr@cavi.au.dk" # Consent-O-Matic
    "addon@fastforward.team" # FastForward
    "{6d96bb5e-1175-4ebf-8ab5-5f56f1c79f65}" # Google Analytics Opt-out
    "{6d85dea2-0fb4-4de3-9f8c-264bce9a2296}" # Link Cleaner
    "uBlock0@raymondhill.net" # uBlock Origin

    # "Stop Websites from Doing Stupid Things I Don't Want"
    "{278b0ae0-da9d-4cc6-be81-5aa7f3202672}" # Allow Right Click
    "DontFuckWithPaste@raim.ist" # Don't Fuck With Paste

    # YouTube
    "{9a41dee2-b924-4161-a971-7fb35c053a4a}" # enhanced-h264ify
    "sponsorBlocker@ajay.app" # SponsorBlock for YouTube
    "{0d7cafdd-501c-49ca-8ebb-e3341caaa55e}" # YouTube NonStop

    # Utilities
    "{d634138d-c276-4fc8-924b-40a0ea21d284}" # 1Password
    "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}" # Auto Tab Discard
    "{cb31ec5d-c49a-4e5a-b240-16c767444f62}" # Indie Wiki Buddy
    "octolinker@stefanbuck.com" # OctoLinker
    "firefox-addon@pronoundb.org" # PronounDB
    "wayback_machine@mozilla.org" # Wayback Machine
  ];

  policies = {
    ExtensionSettings = lib.listToAttrs (
      map (
        id:
        lib.nameValuePair id {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
        }
      ) addons
    );
  };

  # TODO: Specifying custom search engines is *very* cursed.
  # I've seen how HM does it, and I don't think it's worth it at all...
in
{
  hjem.users.leah.packages = [ wrappedFirefox ];
}
