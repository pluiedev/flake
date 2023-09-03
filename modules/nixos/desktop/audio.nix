{
  config,
  lib,
  ...
}: let
  cfg = config.pluie.desktop.audio;
  inherit (lib) mkEnableOption mkIf;
in {
  options.pluie.desktop.audio.enable = mkEnableOption "audio support";

  config = mkIf cfg.enable {
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
    };
  };
}
