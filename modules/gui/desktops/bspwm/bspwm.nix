{ lib, cfg, ... }:
{
  # install bspwm
  services.xserver.windowManager.bspwm.enable = true;

  # configure bspwm using home-manager
  home_manager_modules.bspwm.enable = true;
}
