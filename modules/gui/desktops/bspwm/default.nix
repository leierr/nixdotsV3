{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.gui.bspwm;
  style = config.system_settings.style;
in
{
  options.system_settings.gui.bspwm = {
    enable = lib.mkEnableOption "";
    bspwm_config_dir = lib.mkOption { type = lib.types.path; default = ./configs/bspwm; };
    sxhkd_config_dir = lib.mkOption { type = lib.types.path; default = ./configs/sxhkd; };
    polybar_config_dir = lib.mkOption { type = lib.types.path; default = ./configs/polybar; };
    dunst_config_dir = lib.mkOption { type = lib.types.path; default = ./configs/dunst; };
    alacritty_config_dir = lib.mkOption { type = lib.types.path; default = ./configs/alacritty; };
  };

  config = lib.mkIf (cfg.enable && config.system_settings.gui.enable) {
    # install BSPWM on system level
    services.xserver.windowManager.bspwm.enable = true;

    home_manager_modules = [
      ({
        home.file.".config/bspwm" = {
          source = cfg.bspwm_config_dir;
          recursive = true;
        };

        home.file.".config/sxhkd" = {
          source = cfg.sxhkd_config_dir;
          recursive = true;
        };

        home.file.".config/polybar" = {
          source = cfg.polybar_config_dir;
          recursive = true;
        };

        home.file.".config/dunst" = {
          source = cfg.dunst_config_dir;
          recursive = true;
        };

        home.file.".config/alacritty" = {
          source = cfg.alacritty_config_dir;
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
