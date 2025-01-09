{ config, lib, ... }:
let
  cfg = config.roles.audio;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    roles.base.user.extraGroups = [ "rtkit" ];

    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
    };
  };
}
