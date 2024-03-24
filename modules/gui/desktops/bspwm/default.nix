{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.gui.bspwm;
  style = config.system_settings.style;
  #----------------------------------------#
  bspwmrc_config = pkgs.writeShellScript "bspwmrc" ( import ./configs/bspwm/bspwmrc.nix );
in
{
  options.system_settings.gui.bspwm = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf (cfg.enable && config.system_settings.gui.enable) {
    # install BSPWM on system level
    services.xserver.windowManager.bspwm = {
      enable = true;
      configFile = bspwmrc_config;
      package = pkgs.bspwm;
    };
  };
}
