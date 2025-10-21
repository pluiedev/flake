{
  hjem.users.leah = {
    environment.sessionVariables.EDITOR = "hx";

    # TODO: upstream this
    xdg.config.files."helix/ignore".text = ''
      flake.lock
      result/
      zig-out/
      .zig-cache/
    '';

    rum.programs.helix = {
      enable = true;

      settings = {
        theme = "catppuccin_mocha_plus";

        editor = {
          line-number = "relative";
          bufferline = "multiple";
          cursorline = true;
          color-modes = true;
          text-width = 100;
          popup-border = "all";
          rulers = [ 100 ];

          end-of-line-diagnostics = "hint";
          inline-diagnostics = {
            cursor-line = "info";
            other-lines = "error";
          };

          soft-wrap.enable = true;

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };

          statusline = {
            left = [
              "mode"
              "spacer"
              "spinner"
            ];
            right = [
              "read-only-indicator"
              "file-modification-indicator"
              "file-name"
              "separator"
              "file-type"
              "position-percentage"
              "spacer"
              "separator"
              "position"
            ];
            mode = {
              normal = "NORMAL";
              insert = "INSERT";
              select = "VISUAL";
            };
          };

          lsp = {
            display-messages = true;
            display-progress-messages = true;
            display-inlay-hints = true;
          };

          auto-save = {
            focus-lost = true; # Ghostty supports it :)
            after-delay.enable = true;
          };

          whitespace.render = {
            space = "none";
            tab = "all";
          };

          indent-guides.render = true;

          gutters.layout = [
            "diff"
            "diagnostics"
            "line-numbers"
            "spacer"
          ];
        };
        keys = {
          normal = {
            "C-s" = ":w";
            "tab" = "move_parent_node_end";
            "S-tab" = "move_parent_node_start";
            "A-h" = "goto_previous_buffer";
            "A-l" = "goto_next_buffer";
          };
          insert = {
            "S-tab" = "move_parent_node_start";
          };
          select = {
            "tab" = "move_parent_node_end";
            "S-tab" = "move_parent_node_start";
          };
        };
      };
      themes.catppuccin_mocha_plus = {
        inherits = "catppuccin_mocha";

        "ui.statusline" = {
          fg = "subtext0";
          bg = "mantle";
        };
        "ui.statusline.normal" = {
          fg = "mantle";
          bg = "rosewater";
          modifiers = [ "bold" ];
        };
        "ui.statusline.insert" = {
          fg = "mantle";
          bg = "maroon";
          modifiers = [ "bold" ];
        };
        "ui.statusline.select" = {
          fg = "mantle";
          bg = "mauve";
          modifiers = [ "bold" ];
        };

        "ui.cursor.primary.normal" = {
          fg = "base";
          bg = "rosewater";
        };
        "ui.cursor.primary.insert" = {
          fg = "base";
          bg = "maroon";
        };
        "ui.cursor.primary.select" = {
          fg = "base";
          bg = "mauve";
        };

        # Underlines are gross
        "ui.bufferline" = {
          fg = "subtext0";
          bg = "mantle";
          modifiers = [ "dim" ];
        };
        "ui.bufferline.active" = {
          fg = "text";
          bg = "base";
          modifiers = [ "bold" ];
        };

        # Mimick VS Code
        "ui.virtual.inlay-hint" = {
          fg = "overlay0";
          bg = "base";
        };

        "ui.popup".fg = "rosewater";
        "ui.popup.info".fg = "maroon";
        "ui.help".fg = "maroon";
        "ui.menu".fg = "text";
        "ui.menu.selected" = {
          fg = "maroon";
          modifiers = [ "bold" ];
        };
        "ui.menu.scroll".fg = "maroon";
        "ui.background".bg = ""; # Transparent

        # Why the heck is it *blue*?;
        "diff.delta" = "yellow";

        # Maroon itself is already eye-catching enough, no need to italicize
        "variable.parameter" = "maroon";
        # Teal is wayyyyyy too obtrusive in Nix
        "variable.other.member" = "subtext1";
        "variable.builtin" = "peach";

        # Fix ${} in Nix
        "punctuation.special" = "maroon";
        "operator" = "maroon";
      };
    };
  };
}
