{
  config,
  pkgs,
  lib,
  ...
}: {
  hm.home.packages = with pkgs; [
    hyprpicker
    grimblast
    satty
  ];

  hm.wayland.windowManager.hyprland.settings = {
    "$grimblast" = "${lib.getExe pkgs.grimblast} --freeze --notify --cursor";

    env = [
      "GRIMBLAST_EDITOR,${pkgs.writeShellScript "edit.sh" ''
        cp $1 ${config.hm.home.homeDirectory}/Pictures/screenshots
        ${lib.getExe pkgs.satty} --copy-command ${lib.getExe' pkgs.wl-clipboard "wl-copy"} -f $1
      ''}"
    ];

    bind = [
      "CTRL_R, Delete, exec, $grimblast edit area"
      "SHIFT_R, Delete, exec, $grimblast edit active"
      "CTRL_R SHIFT_R, Delete, exec, $grimblast edit output"
      ", Print, exec, $grimblast edit area"
      "SHIFT, Print, exec, $grimblast edit active"
      "CTRL SHIFT, Print, exec, $grimblast edit output"

      # Because of how cursed ASUS's laptop keyboard works
      # (Fn+F6 produces a sequence of keystrokes that correspond to Windows+Shift+S on Windows),
      # I need to do this to make it do what it's intended to do
      "SUPER SHIFT, S, exec, $grimblast edit area"
      "CTRL SUPER SHIFT, S, exec, $grimblast edit output"
      "ALT SUPER SHIFT, S, exec, $grimblast edit active"
    ];
  };
}
