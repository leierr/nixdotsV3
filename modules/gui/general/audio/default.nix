{ config, lib, ... }:

let
  cfg = config.system_settings.gui.audio;
in
{
  options.system_settings.gui.audio = {
    enable = lib.mkEnableOption "";
  };

  config = lib.mkIf (cfg.enable && config.system_settings.gui.enable) {
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
