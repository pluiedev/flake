{
  services.mako = {
    enable = true;
    anchor = "top-right";

    backgroundColor = "#11111bee";
    borderColor = "#f2cdcdee";
    borderRadius = 5;
    textColor = "#cdd6f4";
    defaultTimeout = 5000;
    progressColor = "over #eba0acff";

    extraConfig = ''
      [urgency=high]
      border-color=#f39ba8ee
    '';
  };
}
