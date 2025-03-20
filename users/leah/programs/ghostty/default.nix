{
  inputs',
  ...
}:
{
  hm.programs.ghostty = {
    enable = true;

    package = inputs'.ghostty.packages.default;

    enableFishIntegration = true;

    settings = {
      font-family = "Iosevka";
      font-size = 14;

      background = "#1e1e2e";

      # Who likes CSDs?
      window-decoration = "server";
      window-theme = "ghostty";

      unfocused-split-opacity = 0.8;
      background-opacity = 0.85;
      background-blur-radius = true;

      # Massively improves the nvim experience
      mouse-hide-while-typing = true;

      keybind = [
        "ctrl+shift+up=new_split:up"
        "ctrl+shift+down=new_split:down"
        "ctrl+shift+left=new_split:left"
        "ctrl+shift+right=new_split:right"
        "ctrl+grave_accent=toggle_quick_terminal"
      ];
    };
  };
}
