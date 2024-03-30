{ cfg }:
{
  services.xserver.enable = true;
  services.xserver.displayManager = {
    lightdm.enable = false;
    defaultSession = cfg.default_session;
    gdm = {
      enable = true;
      autoSuspend = false;
      wayland = true;
    };
  };
}
