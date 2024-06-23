{ cfg }:
{
  services.xserver.enable = true;
  services.xserver.displayManager = {
    lightdm.enable = false;
    gdm = {
      enable = true;
      autoSuspend = false;
      wayland = true;
    };
  };
}
