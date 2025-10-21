{
  inputs,
  pkgs,
  ...
}:
{
  # Required by apps like Fuzzel for determing the default terminal
  hjem.users.leah.environment.sessionVariables.TERMINAL = "ghostty";

  hjem.users.leah.rum.programs.ghostty = {
    enable = true;
    package = inputs.ghostty.packages.${pkgs.system}.ghostty;

    settings = {
      font-family = "Iosevka";
      font-size = 14;

      background = "#1e1e2e";

      window-decoration = "client";
      window-theme = "ghostty";

      unfocused-split-opacity = 0.8;
      background-opacity = 0.85;
      background-blur = true;

      # Massively improves the nvim experience
      mouse-hide-while-typing = true;

      quick-terminal-size = "30%";
      quick-terminal-autohide = true;

      keybind = [
        "ctrl+shift+up=new_split:up"
        "ctrl+shift+down=new_split:down"
        "ctrl+shift+left=new_split:left"
        "ctrl+shift+right=new_split:right"
        "alt+shift+left=next_tab"
        "alt+shift+right=previous_tab"
        "global:ctrl+backquote=toggle_quick_terminal"
      ];
    };
  };
}
