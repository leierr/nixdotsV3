{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.system_settings.gui;
in
{
  options.system_settings.gui.enable = lib.mkEnableOption "";

  imports = [
    ./display_manager

    ./desktops/bspwm
    ./desktops/gnome
    ./desktops/hyprland

    ./general/qt
    ./general/gtk
    ./general/pinentry
    ./general/audio
    ./general/fonts
    ./general/theme
    ./general/gaming
    ./general/cursor
    ./general/rofi
    ./general/terminal_emulator
  ];

  config = {
    # default enabled
    system_settings.gui.display_manager.enable = true;
    system_settings.gui.qt.enable = true;
    system_settings.gui.gtk.enable = true;
    system_settings.gui.audio.enable = true;
    system_settings.gui.fonts.enable = true;
    system_settings.gui.pinentry.enable = true;
    system_settings.gui.cursor.enable = true;

    # to get some chromium based programs to work on wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # remove that stupid default terminal
    services.xserver.excludePackages = [ pkgs.xterm ];
  };
}
