{
  pkgs,
  lib,
  ...
}:
{
  hjem.users.leah.packages = with pkgs; [
    jujutsu
    difftastic
    watchman
    hwatch
  ];

  hjem.users.leah.environment.sessionVariables = {
    DFT_DISPLAY = "inline";
    HWATCH = "--no-title --color --mouse --keymap q=force_cancel";
  };

  hjem.users.leah.ext.programs = {
    git = {
      enable = true;
      settings = {
        diff.external = lib.getExe pkgs.difftastic;

        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        url."https://github.com/".insteadOf = "gh:";
        gpg.format = "ssh";

        http.proxy = "http://127.0.0.1:2080";

        user = {
          name = "Leah Amelia Chen";
          email = "hi@pluie.me";
          signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC7uJGE2/25M4a3DIVxtnTA5INqWsFGw+49qHXaN/kqy";
        };
      };
    };

    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "Leah Amelia Chen";
          email = "hi@pluie.me";
        };

        ui = {
          default-command = [ "log" ];
          diff-formatter = "difft";
          pager = "${lib.getExe pkgs.moar} -no-linenumbers";
          log-word-wrap = true;
        };

        aliases = {
          tug = [
            "bookmark"
            "move"
            "--from"
            "closest_bookmark(@-)"
            "--to"
            "closest_pushable(@-)"
          ];

          monitor = [
            "util"
            "exec"
            "--"
            "hwatch"
            "--exec"
            "--limit=1"
            "--"
            "jj"
            "--ignore-working-copy"
            "log"
            "--color=always"
            "-r"
            "current()"
          ];
        };

        revsets = {
          short-prefixes = "current()";
        };

        revset-aliases = {
          "current()" = "(trunk()..@)::";
          "closest_bookmark(to)" = "heads(::to & bookmarks())";
          "closest_pushable(to)" =
            "heads(::to & mutable() & ~description(exact:\"\") & (~empty() | merges()))";
        };

        template-aliases = {
          "format_short_id(id)" = ''id.shortest(12).prefix() ++ "'" ++ id.shortest(12).rest()'';
          "format_timestamp(timestamp)" = "timestamp.ago()";
          "commit_timestamp(commit)" = "commit.author().timestamp()";
          "format_short_signature(signature)" = "signature.name()";
        };

        templates = {
          git_push_bookmark = ''"pluie/jj-" ++ change_id.short()'';
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
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC7uJGE2/25M4a3DIVxtnTA5INqWsFGw+49qHXaN/kqy";
        };

        git = {
          sign-on-push = true;
          private-commits = "description(glob:'wip:*')";
        };

        core = {
          fsmonitor = "watchman";
          watchman.register-snapshot-trigger = true;
        };
      };
    };
  };
}
