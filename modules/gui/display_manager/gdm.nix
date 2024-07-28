{ cfg }:
{
  services.xserver.enable = true;
  services.xserver.displayManager = {
    gdm = {
      enable = true;
      autoSuspend = false;
      wayland = true;
    };
  };
}
