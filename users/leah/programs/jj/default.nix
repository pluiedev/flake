{ config, ... }:
{
  hm.programs.git.difftastic.enable = true;

  hm.programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = config.roles.base.fullName;
        email = "hi@pluie.me";
      };
      ui = {
        diff.tool = [
          "difft"
          "--color=always"
          "$left"
          "$right"
        ];
        log-word-wrap = true;
        pager = ":builtin";
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
        sign-all = true;
        backend = "ssh";
        key = config.roles.base.publicKey;
      };
    };
  };
}
