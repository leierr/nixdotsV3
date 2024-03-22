{ config, lib, ... }:

let
  cfg = config.system_settings.audio;
in
{
  options.system_settings.audio = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = false;
    };

    # Realtime Policy and Watchdog Daemon. Many programs depends on it like pipewire
    security.rtkit.enable = true;
  };
}
