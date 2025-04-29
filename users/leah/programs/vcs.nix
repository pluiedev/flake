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
  ];

  hjem.users.leah.ext.programs = {
    git = {
      enable = true;
      settings = {
        diff.external = "${lib.getExe pkgs.difftastic} --color auto --background light --display side-by-side";

        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        url."https://github.com/".insteadOf = "gh:";
        gpg.format = "ssh";

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
          diff.tool = [
            "${lib.getExe pkgs.difftastic}"
            "--color=always"
            "$left"
            "$right"
          ];
          pager = "${lib.getExe pkgs.moar} -no-linenumbers";
          log-word-wrap = true;
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
