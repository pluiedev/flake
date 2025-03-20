{ pkgs, config, ... }:
{
  hm.programs.git.difftastic.enable = true;

  hm.home.packages = with pkgs; [
    watchman
    meld
  ];

  hm.programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = config.roles.base.fullName;
        email = "hi@pluie.me";
      };
      ui = {
        default-command = ["log"];
        diff.tool = [
          "difft"
          "--color=always"
          "$left"
          "$right"
        ];
        pager = "moar -no-linenumbers";
        diff-editor = "meld";
        merge-editor = "meld";
        log-word-wrap = true;
        editor = "hx";
      };
      template-aliases = {
        "format_short_id(id)" = ''id.shortest(12).prefix() ++ "[" ++ id.shortest(12).rest() ++ "]"'';
        "format_timestamp(timestamp)" = "timestamp.ago()";
        "format_short_signature(signature)" = "signature";
      };

      fix.tools = {
        nixfmt = {
          command = [ "nixfmt" ];
          patterns = [ "glob:'**/*.nix'" ];
        };
      };

      signing = {
        behavior = "drop";
        backend = "ssh";
        key = config.roles.base.publicKey;
      };

      git = {
        sign-on-push = true;
        private-commits = "description(glob:'wip:*')";
      };

      core = {
        fsmonitor = "watchman";
        watchman.register_snapshot_trigger = true;
      };
    };
  };
}
