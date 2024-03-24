{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.gui.bspwm;
  style = config.system_settings.style;
in
{
  options.system_settings.gui.bspwm = {
    enable = lib.mkEnableOption null;
    bspwm_config_dir = mkOption { type = lib.types.path; default = ./configs/bspwm; };
    sxhkd_config_dir = mkOption { type = lib.types.path; default = ./configs/sxhkd; };
    polybar_config_dir = mkOption { type = lib.types.path; default = ./configs/polybar; };
  };

  config = lib.mkIf (cfg.enable && config.system_settings.gui.enable) {
    # install BSPWM on system level
    services.xserver.windowManager.bspwm.enable = true;

    home_manager_modules = [
      ({
        home.file.".config/bspwm" = {
          source = bspwm_config_dir;
          recursive = true;
        };

        home.file.".config/sxhkd" = {
          source = sxhkd_config_dir;
          recursive = true;
        };

        home.file.".config/polybar" = {
          source = polybar_config_dir;
          recursive = true;
        };
      })
    ];

    # dependencies
    environment.systemPackages = with pkgs; [
      sxhkd
      alacritty
      networkmanagerapplet
      pavucontrol
      arandr
      polybar
      flameshot
      picom-next
      dunst
      firefox
      slack
      discord
      feh
      rofi
      xorg.xsetroot
      procps
      killall
      xorg.xrandr
      alsa-utils
      i3lock
      libnotify
      xorg.xprop
    ];
  };
}
