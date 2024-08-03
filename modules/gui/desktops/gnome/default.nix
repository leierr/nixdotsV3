{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.system_settings.gui.desktops.gnome;
  theme = config.system_settings.gui.theme;
  hexToRGBA = (import (inputs.self + "/helper_functions/hex_to_rgba.nix") { inherit lib; });
in
{
  options.system_settings.gui.desktops.gnome = {
    enable = lib.mkEnableOption "";
  };

  config = {
    # install gnome globally
    services.xserver.desktopManager.gnome.enable = true;

    # cool nautilus picture/video previewer
    services.gnome.sushi.enable = true;

    environment.gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
      ]) ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      gnome-terminal
      gedit # text editor
      epiphany # web browser
      geary # email reader
      evince # document viewer
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);

    home_manager_modules = [
      ({
        dconf = {
          settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
        };
      })
    ];
  };
}
