{
  config,
  lib,
  ...
}: let
  cfg = config.roles.audio;
  inherit (lib) mkIf;
in {
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
