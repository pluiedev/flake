{
  hm.programs.ghostty = {
    enable = true;

    settings = {
      font-family = "Iosevka NF";
      font-size = 14;

      background = "#1e1e2e";

      # FIXME: buggy as shit
      # minimum-contrast = 1.4;

      unfocused-split-opacity = 0.7;
      background-opacity = 0.85;

      # Massively improves the nvim experience
      mouse-hide-while-typing = true;

      # I do not like the GTK forehead
      gtk-titlebar = false;
      gtk-wide-tabs = false;

      keybind = [
        "ctrl+shift+down=new_split:down"
        "ctrl+shift+right=new_split:right"

        # No tabs here
        "ctrl+shift+t=unbind"
        "ctrl+page_up=unbind"
        "ctrl+page_down=unbind"
        "alt+two=unbind"
        "alt+three=unbind"
        "alt+four=unbind"
        "alt+five=unbind"
        "alt+six=unbind"
        "alt+seven=unbind"
        "alt+eight=unbind"
        "alt+nine=unbind"
      ];
    };
  };
}
