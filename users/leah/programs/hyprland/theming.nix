{pkgs, ...}: {
  gtk = {
    enable = true;
    font = {
      name = "Rubik";
      size = 11;
      package = pkgs.rubik;
    };
    cursorTheme = {
      name = "Catppuccin-Mocha-Maroon";
      package = pkgs.catppuccin-cursors.mochaMaroon;
      size = 24;
    };
    theme = {
      name = "Catppuccin-Mocha-Compact-Maroon-Dark";

      package = pkgs.catppuccin-gtk.override {
        variant = "mocha";
        tweaks = ["rimless"];
        size = "compact";
        accents = ["maroon"];
      };
    };
  };
}
