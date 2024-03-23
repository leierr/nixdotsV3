{ config, lib, ... }:

let
  cfg = config.system_settings.gui.gdm;
in
{
  options.system_settings.gui.gdm = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf (cfg.enable && config.system_settings.gui.enable) {
    services.xserver.enable = true;
    services.xserver.displayManager = {
      lightdm.enable = false;
      defaultSession = lib.mkIf (config.system_settings.gui.display_manager.default_session != null) config.system_settings.gui.display_manager.default_session;
      gdm = {
        enable = true;
        autoSuspend = false;
        wayland = true;
      };
    };
  };
}
