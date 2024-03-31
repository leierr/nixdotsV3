{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.system_settings.gui;
in
{
  options.system_settings.gui.enable = lib.mkEnableOption "";

  imports = [
    ./display_manager

    ./desktops/bspwm

    ./general/qt
    ./general/gtk
    ./general/pinentry
    ./general/audio
    ./general/fonts
    ./general/theme
    ./general/gaming
  ];

  config = {
    # default enabled
    system_settings.gui.display_manager.enable = lib.mkDefault true;
    system_settings.gui.qt.enable = lib.mkDefault true;
    system_settings.gui.gtk.enable = lib.mkDefault true;
    system_settings.gui.audio.enable = lib.mkDefault true;
    system_settings.gui.fonts.enable = lib.mkDefault true;
    system_settings.gui.pinentry.enable = lib.mkDefault true;
  };
}
