{
  programs.plasma = {
    enable = true;

    configFile = {
      kdeglobals = {
        General = {
          fixed = "Iosevka Nerd Font,11,-1,5,50,0,0,0,0,0";
          font = "Rubik,11,-1,5,50,0,0,0,0,0";
          menuFont = "Rubik,10,-1,5,50,0,0,0,0,0";
          smallestReadableFont = "Rubik,8,-1,5,50,0,0,0,0,0";
          toolBarFont = "Rubik,10,-1,5,50,0,0,0,0,0";
        };
        KDE.SingleClick = false;
        KScreen.ScaleFactor = 1.25;
      };
      kwinrc.NightColor = {
        Active = true;
        EveningBeginFixed = 2200;
        Mode = "Times";
        TransitionTime = 120;
      };
      # Make KRunner appear in the center of the screen, like macOS Spotlight
      krunnerrc.General.FreeFloating = true;
      plasmarc.Theme.name = "breeze-dark";
      kxkbrc.Layout.Options = "terminate:ctrl_alt_bksp,compose:ralt";
    };
  };
}
